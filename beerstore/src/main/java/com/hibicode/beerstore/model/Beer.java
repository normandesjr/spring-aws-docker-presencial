package com.hibicode.beerstore.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

@Data
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Entity
@AllArgsConstructor
@NoArgsConstructor
public class Beer {

    @Id
    @SequenceGenerator(name = "beer_seq", sequenceName =
            "beer_seq", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator
            = "beer_seq")
    @EqualsAndHashCode.Include
    private Long id;

    @NotBlank(message =  "beers-1")
    private String name;

    @NotNull(message =  "beers-2")
    private BeerType type;

    @NotNull(message = "beers-3")
    @DecimalMin(value = "0", message = "beers-4")
    private BigDecimal volume;

    @JsonIgnore
    public boolean isNew() {
        return getId() == null;
    }

    @JsonIgnore
    public boolean alreadyExist() {
        return getId() != null;
    }

}
