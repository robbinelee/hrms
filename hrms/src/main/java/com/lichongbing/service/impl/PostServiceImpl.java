package com.lichongbing.service.impl;

import com.lichongbing.dao.PostDao;
import com.lichongbing.domain.Post;
import com.lichongbing.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
@Service("postService")
public class PostServiceImpl implements PostService {
    @Autowired
    private PostDao postDao;

    public List<Post> findPosts(Map<String, Object> map) {

        return postDao.findPosts(map);
    }

    public Integer getCount(Map<String, Object> map) {

        return postDao.getCount(map);
    }

    public Integer addPost(Post post) {

        return postDao.addPost(post);
    }

    public Integer updatePost(Post post) {

        return postDao.updatePost(post);
    }

    public Integer deletePost(Integer id) {

        return postDao.deletePost(id);
    }

    public Post getPostById(Integer id) {

        return postDao.getPostById(id);
    }

}
