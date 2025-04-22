class InssCalculator
  def self.calculate(salary)
    faixas = [
      [ 0.0, 1045.00, 0.075 ],
      [ 1045.01, 2089.60, 0.09 ],
      [ 2089.61, 3134.40, 0.12 ],
      [ 3134.41, 6101.06, 0.14 ]
    ]
    desconto = 0.0
    faixas.each do |min, max, aliquota|
      break if salary <= min
      faixa_valor = [ salary, max ].min - min
      desconto += faixa_valor * aliquota
    end
    desconto.round(2)
  end
end
