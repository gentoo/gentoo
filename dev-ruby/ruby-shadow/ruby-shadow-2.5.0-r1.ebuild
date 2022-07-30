# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ruby30: does not compile
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="HISTORY README README.euc"

RUBY_FAKEGEM_EXTENSIONS=(./extconf.rb)

inherit ruby-fakegem

DESCRIPTION="ruby shadow bindings"
HOMEPAGE="https://github.com/apalmblad/ruby-shadow http://ttsky.net"

LICENSE="|| ( public-domain Unlicense )"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ~ppc64 ~sparc x86"
IUSE=""
