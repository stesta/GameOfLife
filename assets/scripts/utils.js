// cartesian product
let f = (a, b) => 
          [].concat(...a.map(a => 
             b.map(b => 
               [].concat(a, b))));

export const cartesian = (a, b, ...c) => b ? cartesian(f(a, b), ...c) : a;