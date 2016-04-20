package com.kafaichan.repository;

import com.kafaichan.domain.Person;
import org.springframework.data.neo4j.repository.GraphRepository;

/**
 * Created by kafaichan on 2016/4/19.
 */

public interface PersonRepository extends GraphRepository<Person> {

}
