Ransack.configure do |c|
  c.add_predicate 'lteq_end_of_day', arel_predicate: 'lteq', formatter: proc { |v| v.end_of_day }, compounds: false
  c.hide_sort_order_indicators = false
end
