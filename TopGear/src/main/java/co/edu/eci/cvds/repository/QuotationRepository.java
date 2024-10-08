package co.edu.eci.cvds.repository;

import co.edu.eci.cvds.model.Quotation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface QuotationRepository extends JpaRepository<Quotation, Integer> {
}
