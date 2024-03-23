# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Small RSpec clone weighing less than 350 LoC"
HOMEPAGE="https://leahneukirchen.org/repos/bacon/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/rdoc )"
