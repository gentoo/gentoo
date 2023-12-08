# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="HTML documentation for PHP"
HOMEPAGE="https://secure.php.net/download-docs.php"

MY_PN="php_manual"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"
IUSE=""

RESTRICT="strip binchecks"

LANGS="en de es fr ja pl pt-BR ro tr"
for lang in ${LANGS} ; do
	IUSE+=" l10n_${lang}"
	SRC_URI+=" l10n_${lang}? ( https://dev.gentoo.org/~grknight/distfiles/${MY_PN}_${lang/-/_}-${PV}.tar.gz )"
done

REQUIRED_USE="|| ( ${IUSE} )"

# Set English to default
IUSE="${IUSE/l10n_en/+l10n_en}"

S=${WORKDIR}

src_unpack() {
	for lang in ${LANGS} ; do
		if use l10n_${lang} ; then
			mkdir ${lang/-/_}
			pushd ${lang/-/_} >/dev/null
			unpack ${MY_PN}_${lang/-/_}-${PV}.tar.gz \
				|| die "unpack failed on ${lang}"
			popd >/dev/null
		fi
	done
}

pkg_preinst() {
	# remove broken/stale symlink created by previous ebuilds
	[[ -L ${EROOT}/usr/share/php-docs ]] && rm -f "${EROOT}"/usr/share/php-docs
}

src_install() {
	dodir /usr/share/doc/${PF}

	for lang in ${LANGS} ; do
		if use l10n_${lang} ; then
			ebegin "Installing ${lang} manual, will take a while"
			cp -R "${WORKDIR}"/${lang/-/_} "${ED}"/usr/share/doc/${PF} \
				|| die "cp failed on ${lang}"
			eend $?
		fi
	done

	einfo "Creating symlink to PHP manual at /usr/share/php-docs"
	dosym doc/${PF} /usr/share/php-docs
}
