# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md doc/uname.rdoc"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A Ruby interface for getting operating system information"
HOMEPAGE="https://github.com/djberg96/sys-uname"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/ffi-1.1"
