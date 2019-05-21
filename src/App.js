import React, { lazy, Suspense } from 'react';
import { importMDX } from 'mdx.macro';
import CssBaseline from '@material-ui/core/CssBaseline';
import { MDXProvider } from '@mdx-js/tag';
import components from './components';

const Content = lazy(() => importMDX('./Content.mdx'));

const App = () => (
  <>
    <CssBaseline />
    <MDXProvider components={components}>
      <div>
        <Suspense fallback={<div>Loading...</div>}>
          <Content />
        </Suspense>
      </div>
    </MDXProvider>
  </>
);

export default App;
