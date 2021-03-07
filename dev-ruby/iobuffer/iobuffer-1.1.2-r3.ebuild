# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit multilib ruby-fakegem

GITHUB_USER="tarcieri"

DESCRIPTION="IO::Buffer is a byte queue which is intended for non-blocking I/O applications"
HOMEPAGE="https://github.com/tarcieri/iobuffer"
SRC_URI="https://github.com/${GITHUB_USER}/iobuffer/tarball/v${PV} -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RUBY_S="${GITHUB_USER}-${PN}-*"

all_ruby_prepare() {
	rm .rspec lib/.gitignore Gemfile* || die
}

each_ruby_configure() {
	${RUBY} -C ext extconf.rb || die
	sed -i -e "s/^ldflags  = /ldflags = $\(LDFLAGS\) /" ext/Makefile || die
}

each_ruby_compile() {
	emake -C ext V=1
	cp ext/iobuffer_ext$(get_modname) lib/ || die
}
