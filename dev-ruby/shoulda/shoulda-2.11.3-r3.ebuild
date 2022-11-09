# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="CONTRIBUTION_GUIDELINES.rdoc README.rdoc"

RUBY_FAKEGEM_GEMSPEC=shoulda.gemspec

inherit ruby-fakegem

DESCRIPTION="Making tests easy on the fingers and eyes"
HOMEPAGE="http://thoughtbot.com/projects/shoulda"
SRC_URI="https://github.com/thoughtbot/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="thoughtbot-${PN}-*"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE=""

# tests seem to be quite broken :( They require working version of
# various rails versions. There appear to be unit and matcher tests but
# they can't be run on their own.
RESTRICT=test
