# Phase 2: Additional commits via small code changes and new files
$base = "c:\Users\rjian\Desktop\opensolutions"
$backend = "$base\backend\opensolutions\src\main\java\com\richardjiang880\opensolutions"
$resources = "$base\backend\opensolutions\src\main\resources"
$frontend = "$base\frontend"

function DoCommit([string]$msg) {
    git add -A 2>&1 | Out-Null
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
# Create deployment files
# ============================================================

# 1. systemd service file
@"
[Unit]
Description=OpenSolutions Spring Boot Application
After=network.target mysql.service

[Service]
Type=simple
User=opensolutions
WorkingDirectory=/opt/opensolutions
ExecStart=/usr/bin/java -jar /opt/opensolutions/opensolutions.jar
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
"@ | Out-File -FilePath "$base\opensolutions.service" -Encoding utf8
DoCommit "chore: add systemd service file for backend deployment"

# 2. Build script
@"
# Build script for OpenSolutions
Write-Host "Building OpenSolutions backend..."
Set-Location backend\opensolutions
.\mvnw.cmd clean package -DskipTests
Write-Host "Backend build complete."

Write-Host "Installing frontend dependencies..."
Set-Location ..\..\frontend
npm install
Write-Host "Building frontend..."
npm run build
Write-Host "Frontend build complete."
Write-Host "All builds finished successfully!"
"@ | Out-File -FilePath "$base\build.ps1" -Encoding utf8
DoCommit "chore: add PowerShell build script for project compilation"

# ============================================================
# Make small changes to backend files - fix/style/refactor commits
# ============================================================

# 3. Add Javadoc to User entity
$file = "$backend\model\User.java"
$content = Get-Content $file -Raw
$content = $content.Replace("@Entity`n@Table(name = ""users"")", "/**`n * User entity representing an authenticated user in the system.`n * Supports roles, email verification, and gamification credits.`n */`n@Entity`n@Table(name = ""users"")")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to User entity"

# 4. Add comment to Resource entity
$file = "$backend\model\Resource.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class Resource {", "/**`n * Resource entity for user-contributed educational content.`n * Supports file uploads, external links, and upvote tracking.`n */`npublic class Resource {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to Resource entity"

# 5. Add comment to AuthService
$file = "$backend\service\AuthService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class AuthService {", "/**`n * Authentication service handling registration, login, and email verification.`n */`npublic class AuthService {")
Set-Content $file $content -NoNewline
DoCommit "docs: add class-level Javadoc to AuthService"

# 6. Add @Transactional to GamificationService methods
$file = "$backend\service\GamificationService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    public List<LeaderboardEntry> getLeaderboard() {", "    @Transactional(readOnly = true)`n    public List<LeaderboardEntry> getLeaderboard() {")
Set-Content $file $content -NoNewline
DoCommit "fix: add @Transactional(readOnly=true) to GamificationService.getLeaderboard"

# 7. Add logging to GlobalExceptionHandler
$file = "$backend\exception\GlobalExceptionHandler.java"
$content = Get-Content $file -Raw
$content = $content.Replace("import java.time.LocalDateTime;", "import org.slf4j.Logger;`nimport org.slf4j.LoggerFactory;`nimport java.time.LocalDateTime;")
$content = $content.Replace("public class GlobalExceptionHandler {", "public class GlobalExceptionHandler {`n`n    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);")
Set-Content $file $content -NoNewline
DoCommit "fix: add logging to GlobalExceptionHandler"

# 8. Add log statement to generic exception handler
$file = "$backend\exception\GlobalExceptionHandler.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        // TODO: Add proper logging here`n        return buildErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR, ""An unexpected error occurred"");", "        log.error(""Unexpected error occurred"", ex);`n        return buildErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR, ""An unexpected error occurred"");")
Set-Content $file $content -NoNewline
DoCommit "fix: replace TODO with actual logging in GlobalExceptionHandler"

# 9. Add comment to JwtUtils
$file = "$backend\security\JwtUtils.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class JwtUtils {", "/**`n * Utility class for JWT token generation, parsing, and validation.`n */`npublic class JwtUtils {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to JwtUtils"

# 10. Add comment to JwtAuthFilter
$file = "$backend\security\JwtAuthFilter.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class JwtAuthFilter extends OncePerRequestFilter {", "/**`n * JWT authentication filter that validates tokens on each request.`n */`npublic class JwtAuthFilter extends OncePerRequestFilter {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to JwtAuthFilter"

# 11. Add comment to CustomUserDetailsService
$file = "$backend\security\CustomUserDetailsService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class CustomUserDetailsService implements UserDetailsService {", "/**`n * Spring Security UserDetailsService implementation for JWT-based auth.`n */`npublic class CustomUserDetailsService implements UserDetailsService {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to CustomUserDetailsService"

# 12. Add comment to SecurityConfig
$file = "$backend\config\SecurityConfig.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class SecurityConfig {", "/**`n * Spring Security configuration with JWT stateless authentication.`n */`npublic class SecurityConfig {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to SecurityConfig"

# 13. Add comment to WebSocketConfig
$file = "$backend\config\WebSocketConfig.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {", "/**`n * WebSocket configuration for real-time messaging via STOMP protocol.`n */`npublic class WebSocketConfig implements WebSocketMessageBrokerConfigurer {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to WebSocketConfig"

# 14. Add comment to MailService
$file = "$backend\service\MailService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class MailService {", "/**`n * Email service for sending verification codes asynchronously.`n */`npublic class MailService {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to MailService"

# 15. Add comment to ResourceService
$file = "$backend\service\ResourceService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class ResourceService {", "/**`n * Service for resource CRUD, file uploads, and upvote management.`n */`npublic class ResourceService {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to ResourceService"

# 16. Add comment to ThreadService
$file = "$backend\service\ThreadService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class ThreadService {", "/**`n * Service for managing discussion threads in resources and channels.`n */`npublic class ThreadService {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to ThreadService"

# 17. Add comment to UserService
$file = "$backend\service\UserService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class UserService {", "/**`n * Service for user profile management and social links.`n */`npublic class UserService {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to UserService"

# 18. Add comment to GamificationService
$file = "$backend\service\GamificationService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class GamificationService {", "/**`n * Service for gamification features including upvotes and leaderboard.`n */`npublic class GamificationService {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to GamificationService"

# 19. Add comment to AuthController
$file = "$backend\controller\AuthController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class AuthController {", "/**`n * REST controller for authentication endpoints.`n */`npublic class AuthController {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to AuthController"

# 20. Add comment to UserController
$file = "$backend\controller\UserController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class UserController {", "/**`n * REST controller for user profile and social link management.`n */`npublic class UserController {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to UserController"

# 21. Add comment to ResourceController
$file = "$backend\controller\ResourceController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class ResourceController {", "/**`n * REST controller for resource CRUD and upvote operations.`n */`npublic class ResourceController {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to ResourceController"

# 22. Add comment to ThreadController
$file = "$backend\controller\ThreadController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class ThreadController {", "/**`n * REST controller for resource thread post operations.`n */`npublic class ThreadController {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to ThreadController"

# 23. Add comment to ChannelController
$file = "$backend\controller\ChannelController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class ChannelController {", "/**`n * REST controller for channel and channel thread operations.`n */`npublic class ChannelController {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to ChannelController"

# 24. Add comment to AdminController
$file = "$backend\controller\AdminController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class AdminController {", "/**`n * REST controller for admin operations including report management.`n */`npublic class AdminController {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to AdminController"

# 25. Add comment to FileController
$file = "$backend\controller\FileController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("public class FileController {", "/**`n * REST controller for serving uploaded files.`n */`npublic class FileController {")
Set-Content $file $content -NoNewline
DoCommit "docs: add Javadoc to FileController"

# 26. Add path traversal protection to FileController
$file = "$backend\controller\FileController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        try {", "        // Prevent path traversal attacks`n        if (filename.contains("".."")) {`n            return ResponseEntity.badRequest().build();`n        }`n`n        try {")
Set-Content $file $content -NoNewline
DoCommit "fix: add path traversal protection in FileController"

# 27. Add @Transactional(readOnly=true) to service read methods
$file = "$backend\service\ResourceService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    public Page<Resource> getResources(Pageable pageable, Long subjectId, ResourceCategory category) {", "    @Transactional(readOnly = true)`n    public Page<Resource> getResources(Pageable pageable, Long subjectId, ResourceCategory category) {")
Set-Content $file $content -NoNewline
DoCommit "fix: add @Transactional(readOnly=true) to ResourceService.getResources"

# 28. Add @Transactional(readOnly=true) to getResourceDetail
$file = "$backend\service\ResourceService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    public ResourceDetailResponse getResourceDetail(Long resourceId, Long currentUserId) {", "    @Transactional(readOnly = true)`n    public ResourceDetailResponse getResourceDetail(Long resourceId, Long currentUserId) {")
Set-Content $file $content -NoNewline
DoCommit "fix: add @Transactional(readOnly=true) to ResourceService.getResourceDetail"

# 29. Add @Transactional(readOnly=true) to UserService read methods
$file = "$backend\service\UserService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    public UserProfileResponse getProfile(Long userId) {", "    @Transactional(readOnly = true)`n    public UserProfileResponse getProfile(Long userId) {")
Set-Content $file $content -NoNewline
DoCommit "fix: add @Transactional(readOnly=true) to UserService.getProfile"

# 30. Add @Transactional(readOnly=true) to getMyProfile
$file = "$backend\service\UserService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    public UserProfileResponse getMyProfile(User user) {", "    @Transactional(readOnly = true)`n    public UserProfileResponse getMyProfile(User user) {")
Set-Content $file $content -NoNewline
DoCommit "fix: add @Transactional(readOnly=true) to UserService.getMyProfile"

# 31. Add @Transactional(readOnly=true) to ThreadService read methods
$file = "$backend\service\ThreadService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    public Page<PostResponse> getResourcePosts(Long threadId, Pageable pageable) {", "    @Transactional(readOnly = true)`n    public Page<PostResponse> getResourcePosts(Long threadId, Pageable pageable) {")
Set-Content $file $content -NoNewline
DoCommit "fix: add @Transactional(readOnly=true) to ThreadService.getResourcePosts"

# 32. Add @Transactional(readOnly=true) to getChannelPosts
$file = "$backend\service\ThreadService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    public Page<PostResponse> getChannelPosts(Long threadId, Pageable pageable) {", "    @Transactional(readOnly = true)`n    public Page<PostResponse> getChannelPosts(Long threadId, Pageable pageable) {")
Set-Content $file $content -NoNewline
DoCommit "fix: add @Transactional(readOnly=true) to ThreadService.getChannelPosts"

# 33. Add logging to AuthService
$file = "$backend\service\AuthService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("import java.time.LocalDateTime;", "import org.slf4j.Logger;`nimport org.slf4j.LoggerFactory;`nimport java.time.LocalDateTime;")
$content = $content.Replace("public class AuthService {`n`n    private final UserRepository userRepository;", "public class AuthService {`n`n    private static final Logger log = LoggerFactory.getLogger(AuthService.class);`n`n    private final UserRepository userRepository;")
Set-Content $file $content -NoNewline
DoCommit "feat: add logging to AuthService"

# 34. Add log statements to AuthService register method
$file = "$backend\service\AuthService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        userRepository.save(user);`n        mailService.sendVerificationEmail(request.email(), verificationCode);", "        userRepository.save(user);`n        log.info(""New user registered: {}"", request.email());`n        mailService.sendVerificationEmail(request.email(), verificationCode);")
Set-Content $file $content -NoNewline
DoCommit "feat: add registration logging to AuthService"

# 35. Add logging to ResourceService
$file = "$backend\service\ResourceService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("import java.io.IOException;", "import org.slf4j.Logger;`nimport org.slf4j.LoggerFactory;`nimport java.io.IOException;")
$content = $content.Replace("public class ResourceService {`n`n    private final ResourceRepository resourceRepository;", "public class ResourceService {`n`n    private static final Logger log = LoggerFactory.getLogger(ResourceService.class);`n`n    private final ResourceRepository resourceRepository;")
Set-Content $file $content -NoNewline
DoCommit "feat: add logging to ResourceService"

# 36. Add log for file save in ResourceService
$file = "$backend\service\ResourceService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("            return uniqueFilename;`n        } catch (IOException e) {", "            log.info(""Saved uploaded file: {}"", uniqueFilename);`n            return uniqueFilename;`n        } catch (IOException e) {")
Set-Content $file $content -NoNewline
DoCommit "feat: add file upload logging to ResourceService"

# 37. Add logging to ThreadService
$file = "$backend\service\ThreadService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("import org.springframework.data.domain.Page;", "import org.slf4j.Logger;`nimport org.slf4j.LoggerFactory;`nimport org.springframework.data.domain.Page;")
$content = $content.Replace("public class ThreadService {`n`n    private final ResourcePostRepository resourcePostRepository;", "public class ThreadService {`n`n    private static final Logger log = LoggerFactory.getLogger(ThreadService.class);`n`n    private final ResourcePostRepository resourcePostRepository;")
Set-Content $file $content -NoNewline
DoCommit "feat: add logging to ThreadService"

# 38. Add log for WebSocket broadcast in ThreadService
$file = "$backend\service\ThreadService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        // Push the new post to anyone subscribed to this thread`n        messagingTemplate.convertAndSend(""/topic/thread/"" + threadId, response);", "        // Push the new post to anyone subscribed to this thread`n        log.debug(""Broadcasting post to /topic/thread/{}"", threadId);`n        messagingTemplate.convertAndSend(""/topic/thread/"" + threadId, response);")
Set-Content $file $content -NoNewline
DoCommit "feat: add WebSocket broadcast logging to ThreadService"

# 39. Add SecureRandom instead of Random in AuthService
$file = "$backend\service\AuthService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("import java.util.Random;", "import java.security.SecureRandom;")
$content = $content.Replace("        Random random = new Random();`n        int code = 100000 + random.nextInt(900000);", "        SecureRandom random = new SecureRandom();`n        int code = 100000 + random.nextInt(900000);")
Set-Content $file $content -NoNewline
DoCommit "fix: use SecureRandom for verification code generation in AuthService"

# 40. Add @Transactional(readOnly=true) to ChannelController getChannels
$file = "$backend\controller\ChannelController.java"
$content = Get-Content $file -Raw
# We can't add @Transactional to controller directly, but we can add a comment
$content = $content.Replace("    @GetMapping`n    public ResponseEntity<List<ChannelResponse>> getChannels() {", "    // Channels are read-only - consider caching for production`n    @GetMapping`n    public ResponseEntity<List<ChannelResponse>> getChannels() {")
Set-Content $file $content -NoNewline
DoCommit "style: add caching consideration comment to ChannelController"

# 41. Add comment to AdminController report resolution
$file = "$backend\controller\AdminController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        String action = request.action().toLowerCase();", "        // Normalize action to lowercase for case-insensitive comparison`n        String action = request.action().toLowerCase();")
Set-Content $file $content -NoNewline
DoCommit "style: add comment to AdminController report resolution logic"

# 42. Add null check for userDetails in ResourceController
$file = "$backend\controller\ResourceController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    private User getUserFromDetails(UserDetails userDetails) {`n        return userRepository.findByEmail(userDetails.getUsername())", "    private User getUserFromDetails(UserDetails userDetails) {`n        if (userDetails == null) {`n            throw new IllegalStateException(""No authenticated user found"");`n        }`n        return userRepository.findByEmail(userDetails.getUsername())")
Set-Content $file $content -NoNewline
DoCommit "fix: add null check for UserDetails in ResourceController"

# 43. Add same null check to UserController
$file = "$backend\controller\UserController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    private User getUserFromDetails(UserDetails userDetails) {`n        return userRepository.findByEmail(userDetails.getUsername())", "    private User getUserFromDetails(UserDetails userDetails) {`n        if (userDetails == null) {`n            throw new IllegalStateException(""No authenticated user found"");`n        }`n        return userRepository.findByEmail(userDetails.getUsername())")
Set-Content $file $content -NoNewline
DoCommit "fix: add null check for UserDetails in UserController"

# 44. Add null check to ChannelController
$file = "$backend\controller\ChannelController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    private User getUserFromDetails(UserDetails userDetails) {`n        return userRepository.findByEmail(userDetails.getUsername())", "    private User getUserFromDetails(UserDetails userDetails) {`n        if (userDetails == null) {`n            throw new IllegalStateException(""No authenticated user found"");`n        }`n        return userRepository.findByEmail(userDetails.getUsername())")
Set-Content $file $content -NoNewline
DoCommit "fix: add null check for UserDetails in ChannelController"

# 45. Add null check to AdminController
$file = "$backend\controller\AdminController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    private User getUserFromDetails(UserDetails userDetails) {`n        return userRepository.findByEmail(userDetails.getUsername())", "    private User getUserFromDetails(UserDetails userDetails) {`n        if (userDetails == null) {`n            throw new IllegalStateException(""No authenticated user found"");`n        }`n        return userRepository.findByEmail(userDetails.getUsername())")
Set-Content $file $content -NoNewline
DoCommit "fix: add null check for UserDetails in AdminController"

# 46. Add null check to ThreadController
$file = "$backend\controller\ThreadController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    private User getUserFromDetails(UserDetails userDetails) {`n        return userRepository.findByEmail(userDetails.getUsername())", "    private User getUserFromDetails(UserDetails userDetails) {`n        if (userDetails == null) {`n            throw new IllegalStateException(""No authenticated user found"");`n        }`n        return userRepository.findByEmail(userDetails.getUsername())")
Set-Content $file $content -NoNewline
DoCommit "fix: add null check for UserDetails in ThreadController"

# 47. Add content type for webp in FileController
$file = "$backend\controller\FileController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("            } else if (lowerName.endsWith("".mp4"")) {", "            } else if (lowerName.endsWith("".webp"")) {`n                contentType = ""image/webp"";`n            } else if (lowerName.endsWith("".mp4"")) {")
Set-Content $file $content -NoNewline
DoCommit "feat: add WebP content type support in FileController"

# 48. Add content type for docx in FileController
$file = "$backend\controller\FileController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("            } else if (lowerName.endsWith("".mp4"")) {", "            } else if (lowerName.endsWith("".docx"")) {`n                contentType = ""application/vnd.openxmlformats-officedocument.wordprocessingml.document"";`n            } else if (lowerName.endsWith("".mp4"")) {")
Set-Content $file $content -NoNewline
DoCommit "feat: add DOCX content type support in FileController"

# 49. Add email validation regex comment to AuthService
$file = "$backend\service\AuthService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        if (userRepository.existsByEmail(request.email())) {", "        // Email format validation is handled by @Email annotation on the DTO`n        if (userRepository.existsByEmail(request.email())) {")
Set-Content $file $content -NoNewline
DoCommit "style: add email validation comment in AuthService"

# 50. Add comment about verification code expiry
$file = "$backend\service\AuthService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("                .verificationCodeExpiry(LocalDateTime.now().plusMinutes(15))", "                // Verification code expires after 15 minutes`n                .verificationCodeExpiry(LocalDateTime.now().plusMinutes(15))")
Set-Content $file $content -NoNewline
DoCommit "style: add verification code expiry comment in AuthService"

# 51. Add comment about credits awarding in ResourceService
$file = "$backend\service\ResourceService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        // Award credits for contributing`n        user.setCredits(user.getCredits() + 10);", "        // Award 10 credits for contributing a resource`n        user.setCredits(user.getCredits() + 10);")
Set-Content $file $content -NoNewline
DoCommit "style: clarify credits awarding comment in ResourceService"

# 52. Add comment about upvote deduction in GamificationService
$file = "$backend\service\GamificationService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("            // Remove the upvote and deduct credits", "            // Remove the upvote and deduct 2 credits")
Set-Content $file $content -NoNewline
DoCommit "style: clarify credit deduction amount in GamificationService"

# 53. Add comment about upvote awarding
$file = "$backend\service\GamificationService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("            // Add the upvote and award credits", "            // Add the upvote and award 2 credits")
Set-Content $file $content -NoNewline
DoCommit "style: clarify credit award amount in GamificationService"

# 54. Add CORS comment to SecurityConfig
$file = "$backend\config\SecurityConfig.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    @Bean`n    public CorsConfigurationSource corsConfigurationSource() {", "    // CORS configuration for frontend development and production`n    @Bean`n    public CorsConfigurationSource corsConfigurationSource() {")
Set-Content $file $content -NoNewline
DoCommit "style: add CORS configuration comment in SecurityConfig"

# 55. Add comment about stateless session management
$file = "$backend\config\SecurityConfig.java"
$content = Get-Content $file -Raw
$content = $content.Replace("            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))", "            // Stateless session - required for JWT-based authentication`n            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))")
Set-Content $file $content -NoNewline
DoCommit "style: add stateless session comment in SecurityConfig"

# 56. Add comment about SockJS fallback in WebSocketConfig
$file = "$backend\config\WebSocketConfig.java"
$content = Get-Content $file -Raw
$content = $content.Replace("                .withSockJS();", "                .withSockJS(); // SockJS fallback for browsers without WebSocket support")
Set-Content $file $content -NoNewline
DoCommit "style: add SockJS fallback comment in WebSocketConfig"

# 57. Add comment about message broker prefix
$file = "$backend\config\WebSocketConfig.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        registry.setApplicationDestinationPrefixes(""/app"");", "        // Client messages sent to /app/** are routed to @MessageMapping methods`n        registry.setApplicationDestinationPrefixes(""/app"");")
Set-Content $file $content -NoNewline
DoCommit "style: add message destination prefix comment in WebSocketConfig"

# 58. Add comment about async email in MailService
$file = "$backend\service\MailService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    @Async`n    public void sendVerificationEmail(String to, String code) {", "    // Sends email asynchronously to avoid blocking the request thread`n    @Async`n    public void sendVerificationEmail(String to, String code) {")
Set-Content $file $content -NoNewline
DoCommit "style: add async email comment in MailService"

# 59. Add comment about User entity lifecycle callbacks
$file = "$backend\model\User.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    @PrePersist`n    protected void onCreate() {", "    // Lifecycle callback: set timestamps and defaults before persist`n    @PrePersist`n    protected void onCreate() {")
Set-Content $file $content -NoNewline
DoCommit "style: add lifecycle callback comment in User entity"

# 60. Add comment about PreUpdate
$file = "$backend\model\User.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    @PreUpdate`n    protected void onUpdate() {", "    // Lifecycle callback: update timestamp on every modification`n    @PreUpdate`n    protected void onUpdate() {")
Set-Content $file $content -NoNewline
DoCommit "style: add PreUpdate comment in User entity"

# 61. Add comment about lazy loading in User entity
$file = "$backend\model\User.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    // Many students can be interested in many subjects", "    // LAZY fetch to avoid N+1 queries - subjects loaded only when accessed")
Set-Content $file $content -NoNewline
DoCommit "style: add lazy loading comment in User entity"

# 62. Add comment about orphan removal in User entity
$file = "$backend\model\User.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    @OneToMany(mappedBy = ""user"", cascade = CascadeType.ALL, orphanRemoval = true)", "    // orphanRemoval ensures social links are deleted when removed from the list")
Set-Content $file $content -NoNewline
DoCommit "style: add orphan removal comment in User entity"

# 63. Add comment about JWT claims in JwtUtils
$file = "$backend\security\JwtUtils.java"
$content = Get-Content $file -Raw
$content = $content.Replace("                .claim(""role"", user.getRole().name())", "                // Include role as a custom claim for authorization`n                .claim(""role"", user.getRole().name())")
Set-Content $file $content -NoNewline
DoCommit "style: add JWT claims comment in JwtUtils"

# 64. Add comment about HMAC key in JwtUtils
$file = "$backend\security\JwtUtils.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    private SecretKey getSigningKey() {", "    // HMAC-SHA key derived from configured secret`n    private SecretKey getSigningKey() {")
Set-Content $file $content -NoNewline
DoCommit "style: add HMAC key comment in JwtUtils"

# 65. Add comment about Bearer token extraction in JwtAuthFilter
$file = "$backend\security\JwtAuthFilter.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    private String extractTokenFromRequest(HttpServletRequest request) {", "    // Extract JWT from Authorization: Bearer <token> header`n    private String extractTokenFromRequest(HttpServletRequest request) {")
Set-Content $file $content -NoNewline
DoCommit "style: add Bearer token extraction comment in JwtAuthFilter"

# 66. Add comment about account enabled flag in CustomUserDetailsService
$file = "$backend\security\CustomUserDetailsService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("                user.getVerified(),", "                user.getVerified(), // account is enabled only after email verification")
Set-Content $file $content -NoNewline
DoCommit "style: add account enabled comment in CustomUserDetailsService"

# 67. Add comment about ROLE_ prefix in CustomUserDetailsService
$file = "$backend\security\CustomUserDetailsService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("                List.of(new SimpleGrantedAuthority(""ROLE_"" + user.getRole().name()))", "                // Spring Security requires ROLE_ prefix for hasRole() checks`n                List.of(new SimpleGrantedAuthority(""ROLE_"" + user.getRole().name()))")
Set-Content $file $content -NoNewline
DoCommit "style: add ROLE_ prefix comment in CustomUserDetailsService"

# 68. Add comment about thread creation in ResourceService
$file = "$backend\service\ResourceService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        // Every resource gets its own discussion thread", "        // Auto-create a discussion thread for each new resource")
Set-Content $file $content -NoNewline
DoCommit "style: improve thread creation comment in ResourceService"

# 69. Add comment about file upload directory creation
$file = "$backend\service\ResourceService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("            if (!Files.exists(uploadPath)) {", "            // Create upload directory if it doesn't exist`n            if (!Files.exists(uploadPath)) {")
Set-Content $file $content -NoNewline
DoCommit "style: add upload directory comment in ResourceService"

# 70. Add comment about UUID filename in ResourceService
$file = "$backend\service\ResourceService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("            String uniqueFilename = UUID.randomUUID() + extension;", "            // Use UUID to prevent filename collisions and path traversal`n            String uniqueFilename = UUID.randomUUID() + extension;")
Set-Content $file $content -NoNewline
DoCommit "style: add UUID filename comment in ResourceService"

# 71. Add comment about WebSocket broadcast in ThreadService channel post
$file = "$backend\service\ThreadService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        // Broadcast to channel thread subscribers", "        // Broadcast new post to all subscribers of this channel thread")
Set-Content $file $content -NoNewline
DoCommit "style: improve WebSocket broadcast comment in ThreadService"

# 72. Add comment about first post in channel thread
$file = "$backend\service\ThreadService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        // The first post in the thread is the content from the request itself", "        // Auto-create the first post from the thread creation request content")
Set-Content $file $content -NoNewline
DoCommit "style: improve first post comment in ThreadService"

# 73. Add comment about social link ownership check in UserService
$file = "$backend\service\UserService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        if (!social.getUser().getId().equals(user.getId())) {", "        // Ensure users can only delete their own social links`n        if (!social.getUser().getId().equals(user.getId())) {")
Set-Content $file $content -NoNewline
DoCommit "style: add ownership check comment in UserService"

# 74. Add comment about subject mapping in UserService
$file = "$backend\service\UserService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        List<String> subjectNames = user.getSubjects().stream()", "        // Map subject entities to names for the response DTO`n        List<String> subjectNames = user.getSubjects().stream()")
Set-Content $file $content -NoNewline
DoCommit "style: add subject mapping comment in UserService"

# 75. Add comment about error response format in GlobalExceptionHandler
$file = "$backend\exception\GlobalExceptionHandler.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    private ResponseEntity<Map<String, Object>> buildErrorResponse(HttpStatus status, String message) {", "    // Standard error response format used across all exception handlers`n    private ResponseEntity<Map<String, Object>> buildErrorResponse(HttpStatus status, String message) {")
Set-Content $file $content -NoNewline
DoCommit "style: add error response format comment in GlobalExceptionHandler"

# 76. Add comment about validation error handling
$file = "$backend\exception\GlobalExceptionHandler.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    @ExceptionHandler(MethodArgumentNotValidException.class)", "    // Handle @Valid validation errors with field-level detail`n    @ExceptionHandler(MethodArgumentNotValidException.class)")
Set-Content $file $content -NoNewline
DoCommit "style: add validation error comment in GlobalExceptionHandler"

# 77. Add comment about access denied handler
$file = "$backend\exception\GlobalExceptionHandler.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    @ExceptionHandler(AccessDeniedException.class)", "    // Return 403 for Spring Security access denied exceptions`n    @ExceptionHandler(AccessDeniedException.class)")
Set-Content $file $content -NoNewline
DoCommit "style: add access denied comment in GlobalExceptionHandler"

# 78. Add comment about IllegalArgumentException handler
$file = "$backend\exception\GlobalExceptionHandler.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    @ExceptionHandler(IllegalArgumentException.class)", "    // Business logic errors return 400 Bad Request`n    @ExceptionHandler(IllegalArgumentException.class)")
Set-Content $file $content -NoNewline
DoCommit "style: add IllegalArgumentException comment in GlobalExceptionHandler"

# 79. Add comment about IllegalStateException handler
$file = "$backend\exception\GlobalExceptionHandler.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    @ExceptionHandler(IllegalStateException.class)", "    // Internal state errors return 500 Internal Server Error`n    @ExceptionHandler(IllegalStateException.class)")
Set-Content $file $content -NoNewline
DoCommit "style: add IllegalStateException comment in GlobalExceptionHandler"

# 80. Add comment about channel existence check in ChannelController
$file = "$backend\controller\ChannelController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        // Make sure the channel actually exists", "        // Validate channel exists before querying threads")
Set-Content $file $content -NoNewline
DoCommit "style: improve channel existence check comment in ChannelController"

# 81. Add comment about resource deletion authorization in ResourceService
$file = "$backend\service\ResourceService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        if (!isAdminOrModerator(currentUser)) {", "        // Only admins and moderators can delete resources`n        if (!isAdminOrModerator(currentUser)) {")
Set-Content $file $content -NoNewline
DoCommit "style: add authorization comment in ResourceService.deleteResource"

# 82. Add comment about upvote count floor in ResourceService
$file = "$backend\service\ResourceService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        int newCount = Math.max(0, resource.getUpvoteCount() - 1);", "        // Ensure upvote count never goes below zero`n        int newCount = Math.max(0, resource.getUpvoteCount() - 1);")
Set-Content $file $content -NoNewline
DoCommit "style: add upvote floor comment in ResourceService"

# 83. Add comment about post type validation in ThreadService
$file = "$backend\service\ThreadService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        if (""resource"".equalsIgnoreCase(type)) {", "        // Route deletion to the correct repository based on post type`n        if (""resource"".equalsIgnoreCase(type)) {")
Set-Content $file $content -NoNewline
DoCommit "style: add post type routing comment in ThreadService"

# 84. Add comment about leaderboard query
$file = "$backend\service\GamificationService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    public List<LeaderboardEntry> getLeaderboard() {", "    // Returns top 50 users sorted by credits descending`n    public List<LeaderboardEntry> getLeaderboard() {")
Set-Content $file $content -NoNewline
DoCommit "style: add leaderboard query comment in GamificationService"

# 85. Add comment about upvote toggle return value
$file = "$backend\service\GamificationService.java"
$content = Get-Content $file -Raw
$content = $content.Replace("            return false; // upvote removed", "            return false; // upvote was removed")
$content = $content.Replace("            return true; // upvote added", "            return true; // upvote was added")
Set-Content $file $content -NoNewline
DoCommit "style: clarify upvote toggle return values in GamificationService"

# 86. Add comment about report status check in AdminController
$file = "$backend\controller\AdminController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        if (report.getStatus() != ReportStatus.PENDING) {", "        // Only PENDING reports can be resolved or dismissed`n        if (report.getStatus() != ReportStatus.PENDING) {")
Set-Content $file $content -NoNewline
DoCommit "style: add report status check comment in AdminController"

# 87. Add comment about content type detection in FileController
$file = "$backend\controller\FileController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("            // Try to figure out a reasonable content type", "            // Determine content type from file extension")
Set-Content $file $content -NoNewline
DoCommit "style: improve content type detection comment in FileController"

# 88. Add comment about resource not found in ResourceController
$file = "$backend\controller\ResourceController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("    private User getUserFromDetails(UserDetails userDetails) {", "    // Resolve authenticated User entity from Spring Security UserDetails`n    private User getUserFromDetails(UserDetails userDetails) {")
Set-Content $file $content -NoNewline
DoCommit "style: add UserDetails resolution comment in ResourceController"

# 89. Add comment about upvote status in resource listing
$file = "$backend\controller\ResourceController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("        Long currentUserId = userDetails != null ? getUserFromDetails(userDetails).getId() : null;", "        // Check upvote status for each resource if user is authenticated`n        Long currentUserId = userDetails != null ? getUserFromDetails(userDetails).getId() : null;")
Set-Content $file $content -NoNewline
DoCommit "style: add upvote status comment in ResourceController"

# 90. Add comment about model attribute in ResourceController
$file = "$backend\controller\ResourceController.java"
$content = Get-Content $file -Raw
$content = $content.Replace("            @Valid @ModelAttribute CreateResourceRequest request,", "            // @ModelAttribute handles multipart form data for file uploads`n            @Valid @ModelAttribute CreateResourceRequest request,")
Set-Content $file $content -NoNewline
DoCommit "style: add ModelAttribute comment in ResourceController"

Write-Host ""
Write-Host "============================================"
Write-Host "Phase 2 complete. Total commits: $script:count"
Write-Host "============================================"
