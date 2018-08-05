package com.hibicode.beerstore.service;

import com.hibicode.beerstore.model.Beer;
import com.hibicode.beerstore.model.BeerType;
import com.hibicode.beerstore.repository.Beers;
import com.hibicode.beerstore.service.exception
        .BeerAlreadyExistException;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.math.BigDecimal;
import java.util.Optional;

import static org.mockito.Mockito.when;
import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.MatcherAssert.assertThat;

public class BeerServiceTest {

    @Mock
    private Beers beersMocked;

    private BeerService beerService;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        beerService = new BeerService(beersMocked);
    }

    @Test(expected = BeerAlreadyExistException.class)
    public void should_deny_creation_of_beer_that_exist() {
        final Beer beerInDatabase = new Beer(10L, "Heineken",
                BeerType.LAGER, new BigDecimal("355"));
        when(beersMocked.findByNameAndType("Heineken", BeerType
                .LAGER)).thenReturn(Optional.of(beerInDatabase));

        final Beer newBeer = new Beer(null, "Heineken", BeerType
                .LAGER, new BigDecimal("355"));

        beerService.save(newBeer);
    }

    @Test
    public void should_create_new_beer() {
        when(beersMocked.findByNameAndType("Heineken", BeerType
                .LAGER)).thenReturn(Optional.ofNullable(null));

        final Beer newBeer = new Beer(null, "Heineken", BeerType
                .LAGER, new BigDecimal("600"));
        final Beer beerMocked = new Beer(10L, "Heineken", BeerType
                .LAGER, new BigDecimal("600"));
        when(beersMocked.save(newBeer)).thenReturn(beerMocked);

        final Beer beerSaved = beerService.save(newBeer);

        assertThat(beerSaved.getId(), equalTo(10L));
        assertThat(beerSaved.getName(), equalTo("Heineken"));
        assertThat(beerSaved.getType(), equalTo(BeerType.LAGER));
    }

    @Test
    public void should_update_beer_volume() {
        final Beer beerInDatabase = new Beer(10L, "Ultimate New",
                BeerType.IPA, new BigDecimal("500"));
        when(beersMocked.findByNameAndType("Ultimate New",
                BeerType.IPA)).thenReturn(Optional.of(beerInDatabase));

        final Beer beerToUpdate = new Beer(10L, "Ultimate New",
                BeerType.IPA, new BigDecimal("200"));
        final Beer beerMocked = new Beer(10L, "Ultimate New",
                BeerType.IPA, new BigDecimal("200"));
        when(beersMocked.save(beerToUpdate)).thenReturn(beerMocked);

        final Beer beerUpdated = beerService.save(beerToUpdate);
        assertThat(beerUpdated.getId(), equalTo(10L));
        assertThat(beerUpdated.getName(), equalTo("Ultimate New"));
        assertThat(beerUpdated.getType(), equalTo(BeerType.IPA));
        assertThat(beerUpdated.getVolume(), equalTo(new BigDecimal
                ("200")));
    }

    @Test(expected = BeerAlreadyExistException.class)
    public void should_deny_update_of_an_existing_beer_that_already_exists() {
        final Beer beerInDatabase = new Beer(10L, "Heineken",
                BeerType.LAGER, new BigDecimal("355"));
        when(beersMocked.findByNameAndType("Heineken", BeerType
                .LAGER)).thenReturn(Optional.of(beerInDatabase));

        final Beer beerToUpdate = new Beer(5L, "Heineken",
                BeerType.LAGER, new BigDecimal("355"));

        beerService.save(beerToUpdate);
    }

}
