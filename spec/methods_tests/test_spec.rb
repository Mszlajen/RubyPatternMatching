require 'rspec'
require_relative '../../lib/RubyPatternMatching'

describe 'Pattern Matching' do
  describe 'unitary test for pattern matching methods' do
    describe 'matches?' do
      it 'ejecuta el bloque al encontrar el patron' do
        resultado = false
        PatternMatching.matches?(5) do
          with(val(5)) {resultado = true}
        end
        expect(resultado).to be true
      end

      it 'deja de buscar al encontrar un patron correcto' do
        resultado = 0
        PatternMatching.matches?(5) do
          with(type(String)) { resultado = 1 }
          with(val(5)) {resultado = 2}
          with(duck(:+)) {resultado = 3}
        end
        expect(resultado).to eq(2)
      end

      it 'ejecuta el bloque de otherwise si no encuentra patron' do
        resultado1 = 0
        PatternMatching.matches?(5) do
          otherwise {resultado1 = 1}
          resultado1 = 2
        end

        resultado2 = 0
        PatternMatching.matches?(5) do
          with(type(String)) {resultado2 = 1}
          otherwise {resultado2 = 2}
          resultado2 = 3
        end

        expect(resultado1).to eq(1)
        expect(resultado2).to eq(2)
      end

      it 'levanta PatterNotFound si termina los with sin otherwise' do
        expect do
          PatternMatching.matches?(false) do
            with(val(true)) {}
          end
        end.to raise_error(PatternNotFound)
      end

      it 'retorna el valor del bloque que se ejecuto' do
        ret = false
        ret = PatternMatching.matches? (2) do
          with(val(2)) { true }
        end
        expect(ret).to be true
      end

      it 'matches? name can be skipped' do
        result = false
        PatternMatching.(true) do
          otherwise {result = true}
        end

        expect(result).to be true
      end
    end

  end
end