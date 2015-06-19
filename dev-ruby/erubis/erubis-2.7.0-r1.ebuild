# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/erubis/erubis-2.7.0-r1.ebuild,v 1.6 2015/04/19 18:21:12 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Erubis is an implementation of eRuby"
HOMEPAGE="http://www.kuwata-lab.com/erubis/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/abstract-1.0.0"

all_ruby_prepare() {
	# These tests now fail due to other ordering and fact that sym
	# are now returned.
	rm test/test-users-guide.rb || die
	sed -i -e '/test-users-guide/ s:^:#:' test/test.rb || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*jruby)
			# Avoid test on jruby that fails different on syntax error.
			sed -i -e '/test_syntax2/,/^  end/ s:^:#:' test/test-main.rb || die
			;;
	esac
}

each_ruby_test() {
	case ${RUBY} in
		# http://rubyforge.org/tracker/index.php?func=detail&aid=29484&group_id=1320&atid=5201
		*ruby19)
			einfo "Tests are not compatible with ruby 1.9.3 with Psych as YAML module."
			;;
		*ruby20)
			einfo "Tests are not compatible with ruby 2.0.0 with Psych as YAML module."
			;;
		*)
			PATH="${S}/bin:${PATH}" RUBYLIB="${S}/lib" ${RUBY} -I. test/test.rb || die
			;;
	esac
}
