require 5.006000;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'B::Lint',
    AUTHOR        => 'Joshua ben Jore <jjore@cpan.org>',
    VERSION_FROM  => 'lib/B/Lint.pm',
    ABSTRACT_FROM => 'lib/B/Lint.pm',
    PREREQ_PM     => { 'Module::Pluggable' => 0,
                       'if' => 0,
                       'B' => 0,
                       'constant' => 0},
    LICENSE       => 'perl',
    'SIGN'        => 1,
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean         => { FILES => 'B-Lint-*' },

    # B::Lint is a dual-life module. Must install over core for pre-5.12 perls.
    INSTALLDIRS => $] < 5.012 ? 'perl' : 'site',
    PM          => {
        'lib/B/Lint.pm'       => '$(INST_ARCHLIB)/B/Lint.pm',
        'lib/B/Lint/Debug.pm' => '$(INST_ARCHLIB)/B/Lint/Debug.pm',
    },
  ($ExtUtils::MakeMaker::VERSION gt '6.46' ?
   ('META_MERGE'  =>
    {
      resources =>
      {
        repository  => 'http://github.com/rurban/B-Lint',
        license     => 'http://dev.perl.org/licenses/',
        bugtracker  => {
            web    => 'https://github.com/rurban/B-Lint/issues',
        },
      },
    }
   ) : ()),
);

package MY;
use Config;

sub depend {
  "
README : \$(VERSION_FROM)
	pod2text \$(VERSION_FROM) > README

release : dist
	git tag \$(VERSION)
	cpan-upload \$(DISTVNAME).tar\$(SUFFIX)
	git push
	git push --tags
"
}
