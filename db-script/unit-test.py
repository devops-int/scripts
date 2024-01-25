import unittest
from unittest.mock import patch, Mock
from io import StringIO
from check import get_random_activity


class TestRandomActivityFunction(unittest.TestCase):

    @patch('sys.stdout', new_callable=StringIO)
    def test_get_random_activity_success(self, mock_stdout):
        # Mocking the response from the Bored API
        with patch('requests.get') as mock_requests_get:
            mock_response = Mock()
            mock_response.status_code = 200
            mock_response.json.return_value = {'activity': 'Test Activity'}
            mock_requests_get.return_value = mock_response

            # Run the function
            get_random_activity()

            # Assertions on the printed output
            expected_output = 'The response code is: 200\nRandom Activity \'Test Activity\' inserted into the \'Activity\' table.'
            self.assertEqual(mock_stdout.getvalue().strip(), expected_output)

    @patch('sys.stdout', new_callable=StringIO)
    def test_get_random_activity_failure(self, mock_stdout):
        # Mocking a failed response from the Bored API
        with patch('requests.get') as mock_requests_get:
            mock_response = Mock()
            mock_response.status_code = 500
            mock_requests_get.return_value = mock_response

            # Run the function
            get_random_activity()

            # Assertions on the printed output
            expected_output = 'Error. Status code: 500'
            self.assertEqual(mock_stdout.getvalue().strip(), expected_output)

if __name__ == '__main__':
    unittest.main()