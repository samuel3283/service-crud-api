package com.reto.service;

import com.reto.model.Producto;
import com.reto.repository.ProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.ArrayList;

@Service
public class ProductoService {
    
    @Autowired
    private ProductoRepository productoRepository;
    
    public List<Producto> findAll() {
        List<Producto> response = new ArrayList<Producto>();
		Producto p1 = new Producto();
		p1.setId(100100L);
		p1.setNombre("Arroz");		
		p1.setDescripcion("Presentación de 5kg");		
		p1.setPrecio(27.00);		
		p1.setCantidad(50);		
		response.add(p1);

		Producto p2 = new Producto();
		p2.setId(100200L);
		p2.setNombre("Azucar");		
		p2.setDescripcion("Presentación de 3kg");		
		p2.setPrecio(18.00);		
		p2.setCantidad(60);		
		response.add(p2);

        return response;
        //return productoRepository.findAll();
    }
    
    public Optional<Producto> findById(Long id) {
        return productoRepository.findById(id);
    }
    
    public Producto save(Producto producto) {
        return productoRepository.save(producto);
    }
    
    public void deleteById(Long id) {
        productoRepository.deleteById(id);
    }
    
    public Producto update(Long id, Producto producto) {
        if (productoRepository.existsById(id)) {
            producto.setId(id);
            return productoRepository.save(producto);
        }
        return null;
    }
}