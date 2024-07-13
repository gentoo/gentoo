# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="lolcat.gemspec"

inherit ruby-fakegem

DESCRIPTION="Rainbows and unicorns!"
HOMEPAGE="https://github.com/busyloop/lolcat"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend "
	dev-ruby/optimist:3
	>=dev-ruby/paint-2.1:0"

all_ruby_prepare() {
	sed -e '/manpages/ s:^:#:' \
		-e 's/git ls-files --/echo/' \
		-e 's/git ls-files/find/' \
		-e '/optimist/ s/3.0.0/3.0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

all_ruby_install() {
	doman man/lolcat.6
	ruby_fakegem_binwrapper lolcat
}
