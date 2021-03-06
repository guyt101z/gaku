module Gaku
  module Grading
    module Collection
      class  Calculations

        attr_reader :grading_methods, :students, :exam

        def initialize(grading_method, students, exam)
          @exam            = exam
          @students        = students
          @grading_methods = grading_method
        end

        def calculate
          {}.tap do |hash|
            @grading_methods.each do |grading_method|
              grading = grading_types[grading_method.grading_type].constantize.new(@exam, @students, grading_method.criteria)
              hash[grading_method.id] = grading.grade
            end
          end
        end

        private

        def grading_types
          ActiveSupport::HashWithIndifferentAccess.new(
            score: 'Gaku::Grading::Collection::Score',
            percentage: 'Gaku::Grading::Collection::Percentage',
            ordinal: 'Gaku::Grading::Collection::Ordinal'
          )
        end
      end
    end
  end
end
