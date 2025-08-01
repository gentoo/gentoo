# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Opens a file or text in the user's preferred editor"
HOMEPAGE="https://github.com/piotrmurach/tty-editor"
SRC_URI="https://github.com/piotrmurach/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

ruby_add_rdepend ">=dev-ruby/tty-prompt-0.22"

all_ruby_prepare() {
	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
	echo '-rspec_helper' > .rspec || die
}

each_ruby_prepare() {
	mkdir tmp || die

	case ${RUBY} in
		*ruby33|*ruby34)
			sed -e 's/* 3/* 5/' -i spec/integration/editor_spec.rb || die
			;;
	esac
}
