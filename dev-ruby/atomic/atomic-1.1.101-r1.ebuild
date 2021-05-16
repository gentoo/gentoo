# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit multilib ruby-fakegem

DESCRIPTION="An atomic reference implementation for JRuby, Rubinius, and MRI"
HOMEPAGE="https://github.com/headius/ruby-atomic"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

all_ruby_prepare() {
	# Avoid compilation dependencies since we compile directly.
	sed -i -e '/:test => :compile/ s:^:#:' \
		-e '/extensiontask/,/end/ s:^:#:' Rakefile || die
}
