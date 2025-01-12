#
# Mysql2Spatial adapter for ActiveRecord
#
# Copyright 2010 Daniel Azuma
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# * Neither the name of the copyright holder, nor the names of any other
#   contributors to this software, may be used to endorse or promote products
#   derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# :stopdoc:

module Arel
  module Visitors
    class MySQL2Spatial < MySQL
      if ::Arel::Visitors.const_defined?(:BindVisitor)
        include ::Arel::Visitors::BindVisitor
      end

      FUNC_MAP = {
        'st_wkttosql' => 'ST_GeomFromText',
        'st_wkbtosql' => 'ST_GeomFromWKB',
        'st_length' => 'ST_GLength'
      }

      include ::RGeo::ActiveRecord::SpatialToSql

      def st_func(standard_name_)
        if (name_ = FUNC_MAP[standard_name_.downcase])
          name_
        elsif standard_name_ =~ /^st_(\w+)$/i
          Regexp.last_match(1)
        else
          standard_name_
        end
      end
    end

    VISITORS['mysql2spatial'] = ::Arel::Visitors::MySQL2Spatial
  end
end

# :startdoc:
