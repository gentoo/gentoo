# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC=iobuffer.gemspec

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit multilib ruby-fakegem

GITHUB_USER="tarcieri"

DESCRIPTION="IO::Buffer is a byte queue which is intended for non-blocking I/O applications"
HOMEPAGE="https://github.com/tarcieri/iobuffer"
SRC_URI="https://github.com/${GITHUB_USER}/iobuffer/archive/v${PV}.tar.gz -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RUBY_S="${GITHUB_USER}-${PN}-*"

all_ruby_prepare() {
	rm .rspec lib/.gitignore Gemfile* || die
}

each_ruby_configure() {
	each_fakegem_configure

	sed -i -e "s/^ldflags  = /ldflags = $\(LDFLAGS\) /" ext/Makefile || die
}
