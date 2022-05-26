# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="FAQ.rdoc README.rdoc USAGE.rdoc"

RUBY_FAKEGEM_EXTENSIONS=(ext/pcaprub_c/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Libpcap bindings for ruby compat"
HOMEPAGE="https://rubygems.org/gems/pcaprub"

LICENSE="LGPL-2.1"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND+="net-libs/libpcap"
RDEPEND+="net-libs/libpcap"

# Tests require live access to a network device as root.
RESTRICT="test"
