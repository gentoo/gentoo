# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ruby-ng-gnome2.eclass
# @MAINTAINER:
# Ruby herd <ruby@gentoo.org>
# @AUTHOR:
# Author: Hans de Graaff <graaff@gentoo.org>
# @BLURB: An eclass to simplify handling of various ruby-gnome2 parts.
# @DESCRIPTION:
# This eclass simplifies installation of the various pieces of
# ruby-gnome2 since they share a very common installation procedure.

RUBY_FAKEGEM_NAME="${RUBY_FAKEGEM_NAME:-${PN#ruby-}}"
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem multilib versionator

IUSE=""

# Define EPREFIX if needed
has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=

subbinding=${PN#ruby-}
if [ $(get_version_component_range "1-2") == "0.19" ]; then
	subbinding=${subbinding/%2}
else
	subbinding=${subbinding/-/_}
	DEPEND="virtual/pkgconfig"
	ruby_add_bdepend "dev-ruby/pkg-config"
fi
if has "${EAPI:-0}" 0 1 2 3 ; then
	S=${WORKDIR}/ruby-gnome2-all-${PV}/${subbinding}
else
	RUBY_S=ruby-gnome2-all-${PV}/${subbinding}
fi
SRC_URI="mirror://sourceforge/ruby-gnome2/ruby-gnome2-all-${PV}.tar.gz"
HOMEPAGE="http://ruby-gnome2.sourceforge.jp/"
LICENSE="Ruby"
SLOT="0"

# @FUNCTION: each_ruby_configure
# @DESCRIPTION:
# Run the configure script in the subbinding for each specific ruby target.
each_ruby_configure() {
	${RUBY} extconf.rb || die "extconf.rb failed"
}

# @FUNCTION: each_ruby_compile
# @DESCRIPTION:
# Compile the C bindings in the subbinding for each specific ruby target.
each_ruby_compile() {
	# We have injected --no-undefined in Ruby as a safety precaution
	# against broken ebuilds, but the Ruby-Gnome bindings
	# unfortunately rely on the lazy load of other extensions; see bug
	# #320545.
	find . -name Makefile -print0 | xargs -0 \
		sed -i -e 's:-Wl,--no-undefined ::' \
		-e "s/^ldflags  = /ldflags = $\(LDFLAGS\) /" \
		|| die "--no-undefined removal failed"

	emake V=1 || die "emake failed"
}

# @FUNCTION: each_ruby_install
# @DESCRIPTION:
# Install the files in the subbinding for each specific ruby target.
each_ruby_install() {
	# Create the directories, or the package will create them as files.
	local archdir=$(ruby_rbconfig_value "sitearchdir")
	dodir ${archdir#${EPREFIX}} /usr/$(get_libdir)/pkgconfig

	emake DESTDIR="${D}" install || die "make install failed"

	each_fakegem_install
}

# @FUNCTION: all_ruby_install
# @DESCRIPTION:
# Install the files common to all ruby targets.
all_ruby_install() {
	for doc in ../AUTHORS ../NEWS ChangeLog README; do
		[ -s "$doc" ] && dodoc $doc
	done
	if [[ -d sample ]]; then
		insinto /usr/share/doc/${PF}
		doins -r sample || die "sample install failed"
	fi

	all_fakegem_install
}
