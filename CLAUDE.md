# Super Bowl Squares - Architecture & Development Guide

## Overview

**Sbsquares** is a Rails 8 application for managing Super Bowl Squares pools. It's a full-stack web application that allows users to purchase squares in a grid, with winners determined by the last digits of team scores across four quarters.

---

## Tech Stack

### Core Framework & Language
- **Ruby 3.3.4** - Specified in `.ruby-version`
- **Rails 8.0.3** - Latest Rails version with modern defaults
- **SQLite 3** - Default database for development and production

### Frontend Stack
- **Turbo Rails** - Server-driven UI with turbo frames for dynamic updates
- **Stimulus Rails** - Lightweight JavaScript framework for interactivity
- **Importmap Rails** - Modern JavaScript module management without Node.js build step
- **Web Awesome** (CSS framework) - Component-based UI with theming system
- **Font Awesome** - Icon library for UI elements
- **CSS (Propshaft)** - Rails' modern asset pipeline

### Backend Features
- **bcrypt** - Password hashing with `has_secure_password`
- **Active Storage** - File attachment system (for team logos)
- **Solid Cache** - Database-backed Rails cache adapter
- **Solid Queue** - Database-backed job queue
- **Solid Cable** - Database-backed WebSocket adapter

### Deployment & Infrastructure
- **Puma** - Application server
- **Thruster** - HTTP asset caching & compression layer
- **Kamal** - Docker-based deployment tool
- **Docker** - Container orchestration for production

### Development & Quality Tools
- **Brakeman** - Security vulnerability scanner
- **Rubocop Rails Omakase** - Ruby style guide enforcement
- **Capybara + Selenium** - System/integration testing
- **Web Console** - Interactive debugging in development

---

## High-Level Architecture

### MVC Structure

#### Models (Core Business Logic)
Located in `/app/models/`:
- **User** - User accounts with roles (member/admin/root), has_secure_password, many-to-many with games through squares
- **Game** - Represents a Super Bowl game with two teams, handles score tracking and winner determination
- **Square** - Individual grid cell; belongs to game and optional user; represents one square in the 10x10 grid
- **Score** - Quarterly scores per game (4 records per game, one per quarter)
- **Session** - Session management using signed cookies (Rails 8 approach)
- **Current** - Thread-local context holder for session and user (ActiveSupport::CurrentAttributes)

**Key Relationships:**
```
Game
  ├── has_many :squares (100 per game)
  ├── has_many :scores (4 per game - one per quarter)
  └── has_many :users (through :squares)

Square
  ├── belongs_to :game
  ├── belongs_to :user (optional - unclaimed squares have nil user_id)
  └── has row/column (0..9) and price attributes

User
  ├── has_many :sessions
  ├── has_many :squares
  └── has_many :games (through :squares)
  └── has role enum (member=0, admin=1, root=2)

Session
  └── belongs_to :user
```

#### Controllers (Request Handling)
Located in `/app/controllers/`:
- **GamesController** - CRUD operations for games, square claiming, score updates, number randomization
  - Custom actions: `claim_squares`, `randomize_numbers`, `edit_scores`, `update_scores`
  - Index allows unauthenticated access; other actions require authentication
- **SquaresController** - CRUD for squares (mostly handled through games)
- **UsersController** - User registration and profile management
- **SessionsController** - Login/logout via signed cookie sessions
- **PasswordsController** - Password reset flow
- **ScoresController** - Score management (accessed through games)

**Authentication Pattern:**
- Uses a custom `Authentication` concern (included in ApplicationController)
- Implements `allow_unauthenticated_access` for specific actions
- Session stored in signed, permanent HTTP-only cookie
- Uses Rails 8's `Current` singleton for thread-safe context

#### Views (User Interface)
Located in `/app/views/`:
- **games/** - List games (index), show game with grid, edit game details
  - Grid UI uses inline styles with Web Awesome classes
  - 10x10 square grid with team numbers on axes
  - Shows owner nickname or "Available" status per square
  - Turbo frames for dynamic updates
- **users/** - Registration, edit profile
- **sessions/** - Login form
- **passwords/** - Password reset form
- **layouts/application.html.erb** - Main layout with header, uses Web Awesome page component

**Web Awesome Theme:**
- Theme classes applied to `<html>` element: `wa-theme-playful wa-palette-rudimentary wa-brand-green`
- Responsive grid layout using `wa-grid`, `wa-cluster`, `wa-stack` components
- Font Awesome icons for visual indicators

#### Key Concerns
Located in `/app/controllers/concerns/`:
- **Authentication** - Handles session resumption, cookie management, and authentication checks

---

## Database Schema

**Location:** `/db/schema.rb` (auto-generated from migrations in `/db/migrate/`)

### Core Tables

**users**
- email_address (unique, indexed)
- password_digest (bcrypt hash)
- first_name, last_name, nickname
- role (integer enum: member=0, admin=1, root=2)
- Timestamps (created_at, updated_at)

**games**
- team_1, team_2 (team names)
- game_date (when the game occurs)
- team_1_numbers, team_2_numbers (10-digit randomized strings)
- square_price (cost per square)
- Timestamps

**squares**
- game_id (foreign key)
- user_id (nullable - unclaimed squares are null)
- row, column (0..9 coordinates)
- price (inherited from game.square_price)
- Timestamps
- Validations: row/column presence and 0..9 inclusion

**scores**
- game_id (foreign key)
- quarter (1..4)
- team_1_score, team_2_score (integer cumulative scores)
- Timestamps

**sessions**
- user_id (foreign key)
- ip_address
- user_agent
- Timestamps

**active_storage_*** tables
- Standard Rails Active Storage for file attachments (team logos)

---

## Game Logic

### Scoring & Winners
1. **Game Setup:** When a Game is created, 100 squares (10x10) and 4 scores (quarters 1-4) are auto-created
2. **Randomization:** Admin/root users can randomize team_1_numbers and team_2_numbers (0-9 shuffled)
3. **Winning Calculation:** 
   - Last digit of cumulative team score matches number in grid
   - `Game#winner(quarter)` finds the winning square by:
     - Getting cumulative scores through the quarter
     - Finding the last digit of each team's score
     - Looking up that digit position in the randomized number strings
     - Locating the square at that row/column intersection
4. **Locked Status:** `Game#is_locked?` returns true when all squares have been claimed (no nil user_ids)

---

## Common Development Commands

### Setup & Installation
```bash
bin/setup                    # Complete setup: bundle install, db:prepare, clear logs
bin/setup --skip-server      # Setup without starting server
```

### Running the Application
```bash
bin/dev                      # Start development server (convenience wrapper)
bin/rails server             # Start Rails server (default: http://localhost:3000)
```

### Database Operations
```bash
bin/rails db:create         # Create development database
bin/rails db:migrate        # Run pending migrations
bin/rails db:schema:load    # Load schema from schema.rb
bin/rails db:seed           # Run seeds.rb for initial data
bin/rails db:drop           # Drop development database
bin/rails db:prepare        # Create and migrate if needed
```

### Testing
```bash
bin/rails test              # Run all tests (MiniTest)
bin/rails test:models       # Run model tests
bin/rails test:controllers  # Run controller tests
bin/rails test:system       # Run system/integration tests (Capybara + Selenium)
```

### Code Quality
```bash
bin/brakeman               # Security vulnerability scan
bin/rubocop                # Ruby code style check
bin/rubocop -A             # Auto-fix style issues
```

### Debugging & Console
```bash
bin/rails console          # Interactive Ruby console with app loaded
bin/rails dbconsole        # SQLite interactive shell
```

### Deployment with Kamal
```bash
bin/kamal setup            # Initial deployment setup
bin/kamal deploy           # Deploy to production
bin/kamal console          # Remote Rails console on production
bin/kamal shell            # Remote bash shell on production
bin/kamal logs -f          # Tail production logs
```

---

## Configuration Files & Their Purposes

### Root-Level Config
- **Gemfile / Gemfile.lock** - Ruby gem dependencies and locked versions
- **.ruby-version** - Specifies Ruby 3.3.4
- **.rubocop.yml** - Code style configuration
- **Dockerfile** - Multi-stage Docker build for production containers
- **config.ru** - Rack application entry point
- **mise.toml** - Tool version management

### `/config/` Directory
- **application.rb** - Core Rails configuration, loads defaults for Rails 8.0, autoload paths
- **routes.rb** - URL routing configuration
  - RESTful resources: users, sessions, passwords, scores, squares, games
  - Custom game routes: claim_squares, randomize_numbers, edit_scores, update_scores
  - Root path: games#index
  
- **database.yml** - Database connection configuration
  - SQLite for all environments
  - Production uses persistent volumes via Kamal
  - Separate databases for cache, queue, and cable
  
- **boot.rb** - Early bootstrap code
- **cable.yml** - Action Cable (WebSocket) configuration
- **cache.yml** - Cache adapter configuration (Solid Cache)
- **queue.yml** - Background job queue configuration (Solid Queue)
- **storage.yml** - Active Storage configuration (file attachment storage)
- **deploy.yml** - Kamal deployment configuration
  - Image: Docker container specification
  - Servers: Deployment targets
  - Proxy: SSL/TLS setup with Let's Encrypt
  - Volumes: Persistent storage for SQLite
  - Asset bridging: Zero-downtime deployments
  
- **importmap.rb** - JavaScript import map configuration (ESM modules)
- **puma.rb** - Puma web server configuration
- **recurring.yml** - Scheduled job configuration
- **credentials.yml.enc** - Encrypted credentials (master.key required)
- **environments/** - Environment-specific overrides
  - development.rb, production.rb, test.rb

### `/db/` Directory
- **schema.rb** - Current database schema (auto-generated, never edit directly)
- **seeds.rb** - Initial data seeding script
- **migrate/** - Migration files that track schema changes
- **cable_migrate/, cache_migrate/, queue_migrate/** - Migrations for Solid Rails adapters

---

## Unique Patterns & Conventions

### 1. Role-Based Access Control
- Users have enum roles: member (default), admin, root (full access)
- Visibility of actions controlled in views: `if Current.user.root?`
- No middleware-level authorization; relies on view conditionals and controller logic
- Root users can: create/edit games, randomize numbers, manage scores

### 2. Server-Driven UI with Turbo
- Heavy use of `turbo-frame` elements for partial page updates
- Scores update without full page reload (turbo frames)
- Squares grid updates dynamically when claimed
- `form_with` uses Turbo by default (no page reload on submit)

### 3. Authentication via Signed Cookies
- Rails 8 pattern: user signs in → creates Session record → sets signed cookie
- `Current.session` and `Current.user` provide thread-safe context
- Sessions tied to user_agent and ip_address for security
- `resume_session` method checks cookie and loads current session

### 4. Square Grid Model
- 10x10 grid = 100 squares per game
- Squares can be claimed one by one (not in bundles) via PATCH to claim_squares
- Grid coordinates: row (team 2) × column (team 1)
- Owner shown as nickname or "Available"

### 5. Automatic Model Callbacks
- Game#after_initialize: Sets default team numbers to "??????????"
- Game#after_create: Creates 100 squares and 4 score records
- User#after_initialize: Sets default nickname to "Stranger"

### 6. Game Logic Encapsulation
- Winner determination in Game model: `Game#winner(quarter)`
- Randomization: `Game#randomize_numbers!`
- Score calculation: `Game#score(team)` returns total points
- Locked status: `Game#is_locked?` checks if all squares claimed

### 7. Web Awesome Theming
- Single CSS framework for entire UI
- Theme and palette applied globally at HTML level
- Consistent spacing/layout via utility classes (wa-cluster, wa-stack, wa-grid)
- Custom inline styles for grid styling (borders, padding, background colors)

---

## Deployment Architecture

### Local Development
- SQLite database in `storage/development.sqlite3`
- Puma server on http://localhost:3000
- CSS compiled via Propshaft
- JavaScript via importmap (no build step)

### Production (Docker + Kamal)
- Docker image built from Dockerfile (multi-stage)
- Ruby 3.3.4 slim base image
- Built gems pre-compiled with bootsnap
- Assets pre-compiled before deployment
- SQLite databases in persistent Kamal volumes
- Thruster handles HTTP caching/compression
- Solid Cache, Solid Queue, Solid Cable use separate SQLite databases
- Environment variables: RAILS_MASTER_KEY (encrypted), SOLID_QUEUE_IN_PUMA
- Let's Encrypt SSL via Kamal proxy

### Key Deployment Features
- Zero-downtime deployments via asset bridging
- Persistent storage for SQLite files
- Integrated job queue (Solid Queue) runs in Puma process
- Health check endpoint: `/up`

---

## Key Files to Understand

1. **app/models/game.rb** - Core game logic and winner determination
2. **app/controllers/games_controller.rb** - Main game operations and square claiming
3. **app/views/games/show.html.erb** - 10x10 grid UI, main user interface
4. **app/controllers/concerns/authentication.rb** - Session and auth flow
5. **config/routes.rb** - URL routing and custom actions
6. **db/schema.rb** - Database relationships
7. **app/views/layouts/application.html.erb** - Main layout and theme setup

---

## Quick Tips for New Developers

1. **To create a new game:** Use root user account → Games#new → Fill in teams, date, logos, square price
2. **To edit scores:** Game show page (root only) → Edit Scores link → Update quarter scores
3. **To see winners:** Randomize numbers, set scores to populate the 4 winners (one per quarter)
4. **Authentication context:** Use `Current.user` and `Current.session` anywhere in the app (thread-safe)
5. **Adding features:** Follow REST conventions; use `allow_unauthenticated_access` for public pages
6. **Testing:** System tests in `/test/system/` use Capybara and Selenium for integration testing
7. **Migrations:** Create with `bin/rails generate migration MigrationName`; never edit schema.rb directly
8. **Deployment:** Update `/config/deploy.yml` with server IP and registry info, then `bin/kamal deploy`

