package com.richardjiang880.opensolutions.repository;

import com.richardjiang880.opensolutions.model.ChannelPost;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChannelPostRepository extends JpaRepository<ChannelPost, Long> {

    Page<ChannelPost> findByThreadIdOrderByCreatedAtAsc(Long threadId, Pageable pageable);
}
