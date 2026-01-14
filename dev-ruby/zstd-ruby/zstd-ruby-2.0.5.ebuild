# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

# This gem includes a bundled version of app-arch/zstd. It requires
# features that are only available with a statically linked zstd library
# (e.g. ZSTD_SKIPPABLEHEADERSIZE) and changing the build system to build
# against a statically linked app-arch/zstd does not seem worth it.

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTENSIONS=(ext/zstdruby/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/zstd-ruby"
RUBY_FAKEGEM_GEMSPEC="zstd-ruby.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Ruby binding for zstd (Zstandard - Fast real-time compression algorithm)."
HOMEPAGE="https://github.com/SpringMT/zstd-ruby"
SRC_URI="https://github.com/SpringMT/zstd-ruby/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~ppc64"

all_ruby_prepare() {
	sed -e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC}

	# Removing the -O3 optimization flag causes the test suite to hang
	# consuming CPU.
	# sed -e '/CFLAGS/ s/-O3//' \ -i
	# ext/zstdruby/extconf.rb || die

	sed -e '/bundler/ s:^:#:' \
		-i spec/spec_helper.rb || die

	sed -e '/pry/ s:^:#:' \
		-i spec/zstd-ruby-stream_reader_spec.rb || die
}
