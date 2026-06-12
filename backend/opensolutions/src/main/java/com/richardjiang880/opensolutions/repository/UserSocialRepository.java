package com.richardjiang880.opensolutions.repository;

import com.richardjiang880.opensolutions.model.UserSocial;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserSocialRepository extends JpaRepository<UserSocial, Long> {

    List<UserSocial> findByUserId(Long userId);
}
