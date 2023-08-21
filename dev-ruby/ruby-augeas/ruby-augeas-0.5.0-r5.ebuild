# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_DOCDIR="doc/site/api"
RUBY_FAKEGEM_EXTRADOC="NEWS README.rdoc"

RUBY_FAKEGEM_EXTENSIONS=(ext/augeas/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Ruby bindings for Augeas"
HOMEPAGE="https://augeas.net/"
SRC_URI="http://download.augeas.net/ruby/${P}.gem"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ~ppc64 ~riscv ~sparc x86"
IUSE=""

RDEPEND=">=app-admin/augeas-1.1.0"
DEPEND="${RDEPEND}
		dev-libs/libxml2"
