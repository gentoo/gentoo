# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

inherit ruby-fakegem

DESCRIPTION="SSH private and public key generator in pure Ruby"
HOMEPAGE="https://rubygems.org/gems/sshkey"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~x86"
