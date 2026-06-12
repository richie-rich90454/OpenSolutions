# Commit script for OpenSolutions project
# Each file gets committed individually or in small logical groups

$base = "c:\Users\rjian\Desktop\opensolutions"
$backend = "$base\backend\opensolutions\src\main\java\com\richardjiang880\opensolutions"
$resources = "$base\backend\opensolutions\src\main\resources"
$frontend = "$base\frontend"

function DoCommit([string]$msg, [string[]]$files) {
    foreach ($f in $files) {
        git add $f 2>&1 | Out-Null
    }
    $result = git commit -m $msg 2>&1
    if ($LASTEXITCODE -eq 0) {
        $script:count++
        Write-Host "Commit #$script:count : $msg"
    } else {
        Write-Host "SKIPPED (no changes): $msg"
    }
}

$script:count = 0

# ============================================================
# Backend Phase 1: Foundation
# ============================================================
DoCommit "chore: add jjwt and spring-security dependencies to pom.xml" @("$base\backend\opensolutions\pom.xml")
DoCommit "feat: enable async support in OpensolutionsApplication" @("$backend\OpensolutionsApplication.java")
DoCommit "feat: add Flyway migration for initial database schema" @("$resources\db\migration\V1__init_schema.sql")
DoCommit "feat: configure application.properties with MySQL, JWT, mail, and upload settings" @("$resources\application.properties")

# ============================================================
# Backend Phase 2: Enums
# ============================================================
DoCommit "feat: add Role enum for user authorization" @("$backend\model\Role.java")
DoCommit "feat: add ResourceCategory enum for resource classification" @("$backend\model\ResourceCategory.java")
DoCommit "feat: add ResourceType enum for resource type distinction" @("$backend\model\ResourceType.java")
DoCommit "feat: add ReportStatus enum for report workflow states" @("$backend\model\ReportStatus.java")
DoCommit "feat: add ReportTargetType enum for reportable entity types" @("$backend\model\ReportTargetType.java")

# ============================================================
# Backend Phase 3: Core Entities
# ============================================================
DoCommit "feat: create User entity with Lombok and JPA annotations" @("$backend\model\User.java")
DoCommit "feat: add Subject entity for academic subject categorization" @("$backend\model\Subject.java")
DoCommit "feat: add Topic entity linked to Subject" @("$backend\model\Topic.java")
DoCommit "feat: add Course entity for course management" @("$backend\model\Course.java")
DoCommit "feat: create Resource entity with upvote and thread relationships" @("$backend\model\Resource.java")
DoCommit "feat: add Upvote entity for resource voting" @("$backend\model\Upvote.java")
DoCommit "feat: add ResourceThread entity for resource discussion threads" @("$backend\model\ResourceThread.java")
DoCommit "feat: add ResourcePost entity for thread replies" @("$backend\model\ResourcePost.java")
DoCommit "feat: add Channel entity for community channels" @("$backend\model\Channel.java")
DoCommit "feat: add ChannelThread entity for channel discussions" @("$backend\model\ChannelThread.java")
DoCommit "feat: add ChannelPost entity for channel thread replies" @("$backend\model\ChannelPost.java")
DoCommit "feat: add Report entity for content moderation" @("$backend\model\Report.java")
DoCommit "feat: add UserSocial entity for social profile links" @("$backend\model\UserSocial.java")

# ============================================================
# Backend Phase 4: DTOs
# ============================================================
DoCommit "feat: add RegisterRequest DTO for user registration" @("$backend\dto\RegisterRequest.java")
DoCommit "feat: add LoginRequest DTO for authentication" @("$backend\dto\LoginRequest.java")
DoCommit "feat: add VerifyEmailRequest DTO for email verification" @("$backend\dto\VerifyEmailRequest.java")
DoCommit "feat: add AuthResponse DTO with JWT token" @("$backend\dto\AuthResponse.java")
DoCommit "feat: add UserProfileResponse DTO for user profile data" @("$backend\dto\UserProfileResponse.java")
DoCommit "feat: add UpdateProfileRequest DTO for profile updates" @("$backend\dto\UpdateProfileRequest.java")
DoCommit "feat: add UserSocialRequest DTO for social link creation" @("$backend\dto\UserSocialRequest.java")
DoCommit "feat: add UserSocialDto for social link display" @("$backend\dto\UserSocialDto.java")
DoCommit "feat: add CreateResourceRequest DTO for resource submission" @("$backend\dto\CreateResourceRequest.java")
DoCommit "feat: add ResourceResponse DTO for resource listing" @("$backend\dto\ResourceResponse.java")
DoCommit "feat: add ResourceDetailResponse DTO with thread and upvote data" @("$backend\dto\ResourceDetailResponse.java")
DoCommit "feat: add CreatePostRequest DTO for discussion posts" @("$backend\dto\CreatePostRequest.java")
DoCommit "feat: add PostResponse DTO for post display" @("$backend\dto\PostResponse.java")
DoCommit "feat: add CreateChannelThreadRequest DTO for channel threads" @("$backend\dto\CreateChannelThreadRequest.java")
DoCommit "feat: add ChannelThreadResponse DTO for thread listing" @("$backend\dto\ChannelThreadResponse.java")
DoCommit "feat: add ChannelResponse DTO for channel display" @("$backend\dto\ChannelResponse.java")
DoCommit "feat: add CreateReportRequest DTO for content reporting" @("$backend\dto\CreateReportRequest.java")
DoCommit "feat: add ReportResponse DTO for report display" @("$backend\dto\ReportResponse.java")
DoCommit "feat: add ResolveReportRequest DTO for admin report resolution" @("$backend\dto\ResolveReportRequest.java")
DoCommit "feat: add LeaderboardEntry DTO for gamification rankings" @("$backend\dto\LeaderboardEntry.java")

# ============================================================
# Backend Phase 5: Repositories
# ============================================================
DoCommit "feat: add UserRepository with custom queries" @("$backend\repository\UserRepository.java")
DoCommit "feat: add SubjectRepository for subject data access" @("$backend\repository\SubjectRepository.java")
DoCommit "feat: add TopicRepository for topic data access" @("$backend\repository\TopicRepository.java")
DoCommit "feat: add CourseRepository for course data access" @("$backend\repository\CourseRepository.java")
DoCommit "feat: add ResourceRepository with filtering queries" @("$backend\repository\ResourceRepository.java")
DoCommit "feat: add UpvoteRepository for vote tracking" @("$backend\repository\UpvoteRepository.java")
DoCommit "feat: add ResourceThreadRepository for resource threads" @("$backend\repository\ResourceThreadRepository.java")
DoCommit "feat: add ResourcePostRepository for resource posts" @("$backend\repository\ResourcePostRepository.java")
DoCommit "feat: add ChannelRepository for channel data access" @("$backend\repository\ChannelRepository.java")
DoCommit "feat: add ChannelThreadRepository for channel threads" @("$backend\repository\ChannelThreadRepository.java")
DoCommit "feat: add ChannelPostRepository for channel posts" @("$backend\repository\ChannelPostRepository.java")
DoCommit "feat: add ReportRepository for report management" @("$backend\repository\ReportRepository.java")
DoCommit "feat: add UserSocialRepository for social link data" @("$backend\repository\UserSocialRepository.java")

# ============================================================
# Backend Phase 6: Security
# ============================================================
DoCommit "feat: implement JWT token generation and validation in JwtUtils" @("$backend\security\JwtUtils.java")
DoCommit "feat: add JwtAuthFilter for request authentication" @("$backend\security\JwtAuthFilter.java")
DoCommit "feat: implement CustomUserDetailsService for Spring Security" @("$backend\security\CustomUserDetailsService.java")
DoCommit "feat: configure Spring Security with JWT and route permissions" @("$backend\config\SecurityConfig.java")
DoCommit "feat: add WebSocket configuration for real-time features" @("$backend\config\WebSocketConfig.java")

# ============================================================
# Backend Phase 7: Exception Handling
# ============================================================
DoCommit "feat: add GlobalExceptionHandler for consistent error responses" @("$backend\exception\GlobalExceptionHandler.java")

# ============================================================
# Backend Phase 8: Services
# ============================================================
DoCommit "feat: implement MailService for email verification and notifications" @("$backend\service\MailService.java")
DoCommit "feat: implement AuthService with registration and email verification" @("$backend\service\AuthService.java")
DoCommit "feat: implement ResourceService with CRUD and filtering" @("$backend\service\ResourceService.java")
DoCommit "feat: implement ThreadService for resource and channel threads" @("$backend\service\ThreadService.java")
DoCommit "feat: implement GamificationService with leaderboard and points" @("$backend\service\GamificationService.java")
DoCommit "feat: implement UserService for profile management" @("$backend\service\UserService.java")

# ============================================================
# Backend Phase 9: Controllers
# ============================================================
DoCommit "feat: add AuthController with register, login, and verify endpoints" @("$backend\controller\AuthController.java")
DoCommit "feat: add UserController with profile and leaderboard endpoints" @("$backend\controller\UserController.java")
DoCommit "feat: add ResourceController with CRUD and upvote endpoints" @("$backend\controller\ResourceController.java")
DoCommit "feat: add ThreadController for resource thread management" @("$backend\controller\ThreadController.java")
DoCommit "feat: add ChannelController for channel and thread operations" @("$backend\controller\ChannelController.java")
DoCommit "feat: add AdminController with report and user management" @("$backend\controller\AdminController.java")
DoCommit "feat: add FileController for file upload and serving" @("$backend\controller\FileController.java")

# ============================================================
# Backend: Infrastructure files
# ============================================================
DoCommit "chore: add Maven wrapper properties" @("$base\backend\opensolutions\.mvn\wrapper\maven-wrapper.properties")
DoCommit "chore: add gitattributes for line ending consistency" @("$base\backend\opensolutions\.gitattributes")
DoCommit "chore: add backend .gitignore" @("$base\backend\opensolutions\.gitignore")
DoCommit "chore: add Maven wrapper scripts" @("$base\backend\opensolutions\mvnw" , "$base\backend\opensolutions\mvnw.cmd")
DoCommit "chore: add application test class" @("$base\backend\opensolutions\src\test\java\com\richardjiang880\opensolutions\OpensolutionsApplicationTests.java")

# ============================================================
# Frontend Phase 1: Setup
# ============================================================
DoCommit "chore: initialize React frontend with Vite and dependencies" @("$frontend\package.json")
DoCommit "chore: lock dependency versions in package-lock.json" @("$frontend\package-lock.json")
DoCommit "feat: configure Vite with proxy and build settings" @("$frontend\vite.config.js")
DoCommit "feat: add index.html entry point" @("$frontend\index.html")
DoCommit "chore: add ESLint configuration" @("$frontend\eslint.config.js")
DoCommit "chore: add frontend .gitignore" @("$frontend\.gitignore")
DoCommit "feat: add favicon and icons assets" @("$frontend\public\favicon.svg" , "$frontend\public\icons.svg")
DoCommit "feat: create main.jsx React entry point" @("$frontend\src\main.jsx")
DoCommit "feat: create App.jsx with route configuration" @("$frontend\src\App.jsx")
DoCommit "feat: add global styles in index.css" @("$frontend\src\index.css")
DoCommit "feat: add static assets for frontend" @("$frontend\src\assets\hero.png" , "$frontend\src\assets\react.svg" , "$frontend\src\assets\vite.svg")

# ============================================================
# Frontend Phase 2: Store & API
# ============================================================
DoCommit "feat: create Zustand auth store with login and register actions" @("$frontend\src\store\authStore.js")
DoCommit "feat: add Axios instance with JWT interceptor" @("$frontend\src\api\axios.js")
DoCommit "feat: add auth API module with login, register, verify endpoints" @("$frontend\src\api\auth.js")
DoCommit "feat: add resources API module with CRUD operations" @("$frontend\src\api\resources.js")
DoCommit "feat: add threads API module for discussion management" @("$frontend\src\api\threads.js")
DoCommit "feat: add channels API module for channel operations" @("$frontend\src\api\channels.js")
DoCommit "feat: add users API module for profile and leaderboard" @("$frontend\src\api\users.js")
DoCommit "feat: add reports API module for content moderation" @("$frontend\src\api\reports.js")

# ============================================================
# Frontend Phase 3: Hooks
# ============================================================
DoCommit "feat: create useAuth hook for authentication state" @("$frontend\src\hooks\useAuth.js")
DoCommit "feat: create useResources hook with filtering and pagination" @("$frontend\src\hooks\useResources.js")
DoCommit "feat: create useThreads hook for discussion management" @("$frontend\src\hooks\useThreads.js")
DoCommit "feat: create useChannels hook for channel operations" @("$frontend\src\hooks\useChannels.js")
DoCommit "feat: create useProfile hook for user profile data" @("$frontend\src\hooks\useProfile.js")
DoCommit "feat: create useReports hook for admin report management" @("$frontend\src\hooks\useReports.js")
DoCommit "feat: create useWebSocket hook for real-time updates" @("$frontend\src\hooks\useWebSocket.js")

# ============================================================
# Frontend Phase 4: Components
# ============================================================
DoCommit "feat: create RequireAuth component for route protection" @("$frontend\src\components\RequireAuth.jsx")
DoCommit "feat: create AppLayout component with navigation" @("$frontend\src\components\AppLayout.jsx")

# ============================================================
# Frontend Phase 5: Pages
# ============================================================
DoCommit "feat: create LoginPage with email and password form" @("$frontend\src\pages\LoginPage.jsx")
DoCommit "feat: create RegisterPage with registration form" @("$frontend\src\pages\RegisterPage.jsx")
DoCommit "feat: create VerifyEmailPage with verification code input" @("$frontend\src\pages\VerifyEmailPage.jsx")
DoCommit "feat: create DashboardPage with user stats overview" @("$frontend\src\pages\DashboardPage.jsx")
DoCommit "feat: create ResourcesPage with resource listing and filters" @("$frontend\src\pages\ResourcesPage.jsx")
DoCommit "feat: create ResourceDetailPage with thread discussion" @("$frontend\src\pages\ResourceDetailPage.jsx")
DoCommit "feat: create ChannelsPage with channel listing" @("$frontend\src\pages\ChannelsPage.jsx")
DoCommit "feat: create ChannelThreadPage with thread and posts" @("$frontend\src\pages\ChannelThreadPage.jsx")
DoCommit "feat: create ProfilePage with user info and social links" @("$frontend\src\pages\ProfilePage.jsx")
DoCommit "feat: create LeaderboardPage with ranking display" @("$frontend\src\pages\LeaderboardPage.jsx")
DoCommit "feat: create AdminPage with report and user management" @("$frontend\src\pages\AdminPage.jsx")

# ============================================================
# Root files
# ============================================================
DoCommit "chore: add root .gitignore for project-wide ignores" @("$base\.gitignore")

Write-Host ""
Write-Host "============================================"
Write-Host "Phase 1 complete. Total commits: $script:count"
Write-Host "============================================"
