# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.rdoc README.signals"

RUBY_FAKEGEM_EXTENSIONS=(ext/fcgi/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="FastCGI library for Ruby"
HOMEPAGE="https://github.com/alphallc/ruby-fcgi-ng"

KEYWORDS="amd64 arm ~hppa ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
LICENSE="MIT Ruby-BSD"

DEPEND+=" dev-libs/fcgi"
RDEPEND+=" dev-libs/fcgi"

IUSE=""
SLOT="0"
