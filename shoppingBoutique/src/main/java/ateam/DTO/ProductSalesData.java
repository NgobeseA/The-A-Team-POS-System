/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ateam.DTO;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 *
 * @author T440
 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class ProductSalesData {
    private int productId;
    private int storeId;
    private int totalQuantitySold;
}
