# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.textile"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit multilib ruby-fakegem

DESCRIPTION="A Ruby interface to libshout2"
HOMEPAGE="https://github.com/niko/ruby-shout"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND+=" >=media-libs/libshout-2.0"
DEPEND+=" >=media-libs/libshout-2.0"
