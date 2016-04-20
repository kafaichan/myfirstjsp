package com.kafaichan.domain;

import org.springframework.data.neo4j.annotation.GraphId;
import org.springframework.data.neo4j.annotation.NodeEntity;

/**
 * Created by kafaichan on 2016/4/20.
 */

@NodeEntity
public class Movie {
    @GraphId
    private Long id;


}
