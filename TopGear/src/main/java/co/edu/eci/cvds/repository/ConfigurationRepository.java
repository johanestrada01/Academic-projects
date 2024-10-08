package co.edu.eci.cvds.repository;

import co.edu.eci.cvds.model.Configuration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConfigurationRepository extends JpaRepository<Configuration, String> {

    public List<Configuration> findByPropiedad(String propiedad);

}
