package com.hibicode.beerstore.service.exception;

import org.springframework.http.HttpStatus;

public class EntityNotFoundException extends BusinessException {

    public EntityNotFoundException() {
        super("generic-2", HttpStatus.NOT_FOUND);
    }
}
