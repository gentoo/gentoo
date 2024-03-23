# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
inherit ruby-fakegem

DESCRIPTION="Ruby FFI Rakefile generator"
HOMEPAGE="https://github.com/ffi/ffi/wiki"
SRC_URI="https://github.com/ffi/ffi-compiler/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

ruby_add_rdepend "dev-ruby/rake >=dev-ruby/ffi-1.0.0"
