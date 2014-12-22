class Element
  def search(string)
    queue = []
    root = make_bi_tree(nil, self)
    esa =extract_search_atoms(string)
    queue.push(root)
    until (queue.empty?)
    current = queue.shift
    #some magic
    if current[:childs]
    then
      current[:childs].each { |x| queue.push(x) }
    end
    end
  end

  def make_bi_tree(parent, element)
    params = element.get_params
    if params then params = params.map { |ele|
      param = {:key => ele.get_key, :value => ele.get_data}
      param
    }
    end

    childs = element.get_childs
    value = element.get_value1
    data = {
        :parent => parent,
        :key => element.get_key,
        :value => value,
        :params => params,
        :childs => nil
    }
    if childs then childs = childs.map { |x| make_bi_tree(data, x)} end
    data[:childs]=childs

    data
  end

  def extract_search_atoms (string)
    string_literals = []
    string.gsub(/[\w\[=\]*]+/) { |x| string_literals << x }
    string_literals.map { |str|
      tok = str.match(/(\w+|\*)/)
      tok = tok.to_a
      _, key = tok
      tok = str.scan(/\[(\w+)=(\w+)\]/)
      params = tok.map { |t|
        paramkey, paramvalue = t
        param = {:key => paramkey, :value => paramvalue}
        param
      }
      {
          :key => key,
          :params => params
      }
    }
  end

  def get_params
    result = @data
    if result.kind_of?(Array)
      result = result.find_all { |x|
        x.get_key == '@'.to_sym
      }.first
      if result then result.get_data end
    elsif result.kind_of?(Element)
      return nil if (result.get_key != '@'.to_sym)
      result.get_data
    else
      nil
    end
  end

  def get_childs
    result = @data
    if result.kind_of?(Array)
      result.find_all { |x|
        x.get_key != '@'.to_sym
      }
    elsif result.kind_of?(Element)
      return nil if (result.get_key == '@'.to_sym)
      result.get_data
    else
      nil
    end
  end

  def get_value1
    result = @data
    if result.kind_of?(Array)
      result.find_all { |x|
        x.kind_of?(String)
      }.first
    elsif result.kind_of?(String)
      result
    else
      nil
    end
  end

  def get_data
    @data
  end

end