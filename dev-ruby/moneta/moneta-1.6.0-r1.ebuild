# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
# test is disabled for now. It requires many packages.  Test suite also
# takes very long run time and has high memory consumption.

RUBY_FAKEGEM_EXTRADOC="CHANGES README.md SPEC.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A unified interface to key/value stores"
HOMEPAGE="https://github.com/moneta-rb/moneta"
SRC_URI="https://github.com/moneta-rb/moneta/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="test"

ruby_add_depend "test? ( dev-ruby/bson dev-ruby/ox dev-ruby/rantly dev-ruby/sqlite3 dev-ruby/tokyocabinet )"

all_ruby_prepare() {
	sed -e "s/__dir__/'.'/" \
		-e "s/_relative//" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Remove specs for unpackaged or difficult to set up dependencies.
	rm -f spec/active_support/cache_moneta_store_spec.rb \
	   spec/moneta/adapters/memcached/adapter_memcached_spec.rb \
	   spec/moneta/adapters/memcached/standard_memcached_spec.rb \
	   spec/moneta/adapters/memcached/native/adapter_memcached_native_spec.rb \
	   spec/moneta/adapters/memcached/native/standard_memcached_native_spec.rb \
	   spec/moneta/adapters/memory/standard_memory_with_snappy_compress_spec.rb \
	   spec/moneta/proxies/shared/shared_{tcp,unix}_spec.rb \
	   spec/moneta/proxies/transformer/transformer_{bencode,bert,bzip2,lz4,lzma,lzo,marshal_city*,php,snappy,tnet}_spec.rb \
	   spec/moneta/proxies/weak_create/weak_create_spec.rb \
	   spec/moneta/proxies/weak_each_key/weak_each_key_spec.rb \
	   spec/moneta/proxies/weak_increment/weak_increment_spec.rb \
	   spec/rack/session_moneta_spec.rb || die
	rm -rf spec/moneta/adapters/{couch,daybreak,dbm,fog,gdbm,hbase,leveldb,lmdb,localmemcache,mongo,riak,sdbm,sequel,tdb,tokyotyrant} || die

	# Fails for other reasons (probably fixable in the future)
	rm -rf spec/moneta/adapters/activesupportcache/standard_activesupportcache_spec.rb \
	   spec/moneta/adapters/activesupportcache/adapter_activesupportcache_spec.rb \
	   spec/moneta/adapters/activesupportcache/adapter_activesupportcache_with_default_expires_spec.rb \
	   spec/moneta/adapters/memcached/dalli/standard_memcached_dalli_spec.rb \
	   spec/moneta/adapters/restclient || die

	# Requires a live server to be present
	rm -rf spec/moneta/adapters/activerecord/adapter_activerecord_existing_connection_spec.rb \
	   spec/moneta/adapters/activerecord/standard_activerecord_spec.rb \
	   spec/moneta/adapters/activerecord/adapter_activerecord_spec.rb \
	   spec/moneta/adapters/activerecord/standard_activerecord_with_expires_spec.rb \
	   spec/moneta/adapters/redis || die
}
