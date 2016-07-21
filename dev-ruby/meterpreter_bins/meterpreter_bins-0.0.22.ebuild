# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRAINSTALL="meterpreter"

inherit ruby-fakegem

DESCRIPTION="Compiled binaries for Metasploit's Meterpreter"
HOMEPAGE="https://github.com/rapid7/meterpreter_bins"

#https://github.com/rapid7/meterpreter_bins/issues/5
LICENSE="BSD"

SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

#no tests
RESTRICT=test

RDEPEND="${RDEPEND} !dev-ruby/meterpreter_bins:0"
