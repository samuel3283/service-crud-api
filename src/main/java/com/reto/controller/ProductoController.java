package com.reto.controller;

import com.reto.model.Producto;
import com.reto.service.ProductoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/productos")
@CrossOrigin(origins = "*")
public class ProductoController {
    
    @Autowired
    private ProductoService productoService;
    
    @GetMapping
    public List<Producto> getAllProductos() {

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

        //return productoService.findAll();
        return response;
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Producto> getProductoById(@PathVariable Long id) {
        return productoService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Producto createProducto(@RequestBody Producto producto) {
        return productoService.save(producto);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Producto> updateProducto(@PathVariable Long id, @RequestBody Producto producto) {
        Producto updatedProducto = productoService.update(id, producto);
        return updatedProducto != null ? 
                ResponseEntity.ok(updatedProducto) : 
                ResponseEntity.notFound().build();
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProducto(@PathVariable Long id) {
        if (productoService.findById(id).isPresent()) {
            productoService.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}