# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Communicate with OpenVAS manager through OMP"
HOMEPAGE="https://rubygems.org/gems/openvas-omp"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

PDEPEND="net-analyzer/openvas"

all_ruby_prepare() {
	sed -i '/bundler/d' Rakefile
}
