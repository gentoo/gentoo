# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Ruby FFI Rakefile generator"
HOMEPAGE="https://github.com/ffi/ffi/wiki"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
IUSE=""
# PATCHES=( "${FILESDIR}/respect-cflags.patch" )

ruby_add_rdepend "dev-ruby/rake >=dev-ruby/ffi-1.0.0"
