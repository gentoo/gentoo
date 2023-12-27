# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Color features for Ruby"
HOMEPAGE="https://github.com/red-data-tools/red-colors"

IUSE=""

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~ppc ~riscv ~x86"

ruby_add_rdepend "dev-ruby/matrix"
