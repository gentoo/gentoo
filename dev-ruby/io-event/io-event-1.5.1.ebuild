# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)
RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="sus"

inherit ruby-fakegem

DESCRIPTION="An event loop"
HOMEPAGE="https://github.com/socketry/io-event"
SRC_URI="https://github.com/socketry/io-event/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+io-uring"

RDEPEND="io-uring? ( sys-libs/liburing:= )"
DEPEND="${RDEPEND}"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	# Avoid dependency on unpackaged covered package
	rm -f config/sus.rb || die

	if ! use io-uring ; then
		sed -i -e "s:have_library('uring'):have_library('idonotexist_uring'):" ext/extconf.rb || die
	fi
}
