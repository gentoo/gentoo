# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"
RUBY_FAKEGEM_GEMSPEC="facter.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="A cross-platform ruby library for retrieving facts from operating systems"
HOMEPAGE="http://www.puppetlabs.com/puppet/related-projects/facter/"

LICENSE="Apache-2.0"
SLOT="0"
#IUSE="test"
if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/puppetlabs/facter.git"
	EGIT_BRANCH="master"
else
	[[ "${PV}" = *_rc* ]] || \
	KEYWORDS="~amd64 ~arm64 ~hppa ~ppc64 ~riscv ~x86"
	#KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
	SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

#RESTRICT="!test? ( test )"

ruby_add_rdepend "dev-ruby/hocon <dev-ruby/thor-2.0 dev-ruby/ffi dev-ruby/sys-filesystem"
ruby_add_bdepend "test? ( dev-ruby/simplecov dev-ruby/timecop dev-ruby/webmock )"

PATCHES=(
	"${FILESDIR}"/facter-4.4.3-rspec-gentoo-tweak.patch
	"${FILESDIR}"/facter-4.7.0-gentoo-thor-gemspec.patch
)

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	fi
	ruby-ng_src_unpack
}

all_ruby_prepare() {
	sed -e 's/__dir__/"."/' \
		-e 's/__FILE__/"'${RUBY_FAKEGEM_GEMSPEC}'"/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	# Breaks tests; handle deps ourselves
	sed -e "/require 'bundler/d" -i spec/spec_helper.rb || die
	# dev tasks not needed, but block tests
	for f in tasks/rubocop.rake tasks/check.rake ; do
		test -e ${f} && mv -f ${f}{,.DISABLE}
	done
}
