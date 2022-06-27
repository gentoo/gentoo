# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ruby-ng-gnome2.eclass
# @MAINTAINER:
# Ruby herd <ruby@gentoo.org>
# @AUTHOR:
# Author: Hans de Graaff <graaff@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @PROVIDES: ruby-ng
# @BLURB: An eclass to simplify handling of various ruby-gnome2 parts.
# @DESCRIPTION:
# This eclass simplifies installation of the various pieces of
# ruby-gnome2 since they share a very common installation procedure.

case "${EAPI:-0}" in
	6)	inherit eapi7-ver ;;
	7)	;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

RUBY_FAKEGEM_NAME="${RUBY_FAKEGEM_NAME:-${PN#ruby-}}"
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

# @ECLASS_VARIABLE: RUBY_GNOME2_NEED_VIRTX
# @PRE_INHERIT
# @DESCRIPTION:
# If set to 'yes', the test is run with virtx. Set before inheriting this
# eclass.
: ${RUBY_GNOME2_NEED_VIRTX:="no"}

inherit ruby-fakegem
if [[ ${RUBY_GNOME2_NEED_VIRTX} == yes ]]; then
	inherit virtualx
fi

IUSE="test"
RESTRICT+=" !test? ( test )"

DEPEND="virtual/pkgconfig"
ruby_add_bdepend "
	dev-ruby/pkg-config
	test? ( >=dev-ruby/test-unit-2 )"
SRC_URI="mirror://sourceforge/ruby-gnome2/ruby-gnome2-all-${PV}.tar.gz"
HOMEPAGE="https://ruby-gnome2.osdn.jp/"
LICENSE="LGPL-2.1+"
SLOT="0"
if ver_test -ge "3.4.0"; then
	SRC_URI="https://github.com/ruby-gnome/ruby-gnome/archive/${PV}.tar.gz -> ruby-gnome2-${PV}.tar.gz"
	RUBY_S=ruby-gnome-${PV}/${RUBY_FAKEGEM_NAME}
else
	SRC_URI="mirror://sourceforge/ruby-gnome2/ruby-gnome2-all-${PV}.tar.gz"
	RUBY_S=ruby-gnome2-all-${PV}/${RUBY_FAKEGEM_NAME}
fi

ruby-ng-gnome2_all_ruby_prepare() {
	# Avoid compilation of dependencies during test.
	if [[ -e test/run-test.rb ]]; then
		sed -i -e '/system(/s/which make/true/' test/run-test.rb || die
	fi

	# work on top directory
	pushd .. >/dev/null

	# Avoid native installer
	if [[ -e glib2/lib/mkmf-gnome.rb ]]; then
		sed -i -e '/native-package-installer/ s:^:#:' \
			-e '/^setup_homebrew/ s:^:#:' glib2/lib/mkmf-gnome.rb || die
	fi

	popd >/dev/null
}

all_ruby_prepare() {
	ruby-ng-gnome2_all_ruby_prepare
}

# @FUNCTION: each_ruby_configure
# @DESCRIPTION:
# Run the configure script in the subbinding for each specific ruby target.
each_ruby_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ -e extconf.rb ]] || return

	${RUBY} extconf.rb || die "extconf.rb failed"
}

# @FUNCTION: each_ruby_compile
# @DESCRIPTION:
# Compile the C bindings in the subbinding for each specific ruby target.
each_ruby_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ -e Makefile ]] || return

	# We have injected --no-undefined in Ruby as a safety precaution
	# against broken ebuilds, but the Ruby-Gnome bindings
	# unfortunately rely on the lazy load of other extensions; see bug
	# #320545.
	find . -name Makefile -print0 | xargs -0 \
		sed -i -e 's:-Wl,--no-undefined ::' \
		-e "s/^ldflags  = /ldflags = $\(LDFLAGS\) /" \
		|| die "--no-undefined removal failed"

	emake V=1
}

# @FUNCTION: each_ruby_install
# @DESCRIPTION:
# Install the files in the subbinding for each specific ruby target.
each_ruby_install() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ -e Makefile ]]; then
		# Create the directories, or the package will create them as files.
		local archdir=$(ruby_rbconfig_value "sitearchdir")
		dodir ${archdir#${EPREFIX}} /usr/$(get_libdir)/pkgconfig

		emake DESTDIR="${D}" install
	fi

	each_fakegem_install
}

# @FUNCTION: all_ruby_install
# @DESCRIPTION:
# Install the files common to all ruby targets.
all_ruby_install() {
	debug-print-function ${FUNCNAME} "${@}"

	for doc in ../AUTHORS ../NEWS ChangeLog README; do
		[[ -s ${doc} ]] && dodoc $doc
	done
	if [[ -d sample ]]; then
		insinto /usr/share/doc/${PF}
		doins -r sample
	fi

	all_fakegem_install
}

# @FUNCTION: each_ruby_test
# @DESCRIPTION:
# Run the tests for this package.
each_ruby_test() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ -e test/run-test.rb ]] || return

	if [[ ${RUBY_GNOME2_NEED_VIRTX} == yes ]]; then
		virtx ${RUBY} test/run-test.rb
	else
		${RUBY} test/run-test.rb || die
	fi
}
