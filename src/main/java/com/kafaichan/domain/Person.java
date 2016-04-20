package com.kafaichan.domain;


import org.springframework.data.neo4j.annotation.GraphId;
import org.springframework.data.neo4j.annotation.NodeEntity;

/**
 * Created by kafaichan on 2016/4/19.
 */

@NodeEntity
public class Person {
    @GraphId
    Long id;
    String name;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
