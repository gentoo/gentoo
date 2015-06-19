# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubyzip/rubyzip-0.9.9-r1.ebuild,v 1.13 2015/05/31 10:51:37 maekke Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md TODO NEWS"

inherit ruby-fakegem

DESCRIPTION="A ruby library for reading and writing zip files"
HOMEPAGE="https://github.com/aussiegeek/rubyzip"
# Tests are not included in the gem.
SRC_URI="https://github.com/aussiegeek/rubyzip/tarball/${PV} -> ${P}-git.tgz"
RUBY_S="aussiegeek-rubyzip-*"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${DEPEND} test? ( app-arch/zip )"

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc samples/*
}
