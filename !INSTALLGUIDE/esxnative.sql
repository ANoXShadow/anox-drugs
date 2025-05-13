DELETE FROM items WHERE name IN (
    'weedpowder', 'heroinpowder', 'cocainepowder',
    'cocaleaves', 'weedleaves', 'rawopium',
    'cokepouch', 'heroinpouch', 'weedpouch',
    'plastic_bag'
);

INSERT INTO items (name, label, weight, rare, can_remove) VALUES
('weedpowder', 'Weed Powder', 50, 0, 1),
('heroinpowder', 'Heroin Powder', 50, 0, 1),
('cocainepowder', 'Cocaine Powder', 50, 0, 1),
('cocaleaves', 'Coca Leaves', 100, 0, 1),
('weedleaves', 'Weed Leaves', 100, 0, 1),
('rawopium', 'Raw Opium', 100, 0, 1),
('cokepouch', 'Coke Pouch', 200, 0, 1),
('heroinpouch', 'Heroin Pouch', 200, 0, 1),
('weedpouch', 'Weed Pouch', 200, 0, 1),
('plastic_bag', 'Plastic Bag', 50, 0, 1);
